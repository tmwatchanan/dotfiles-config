#!/usr/bin/env python3
"""8-align the Mach-O LINKEDIT string pool so macOS 27 dyld will load the dylib.

Background: on the macOS 27.0 seed (Darwin 27 / build 26A5353q) dyld rejects any
arm64 dylib whose LC_SYMTAB string table (stroff) is not 8-byte aligned, with:

    dyld: ... (mis-aligned LINKEDIT string pool, fileOffset=0x...)

Both Apple's ld-1328 and LLVM lld place the string table immediately after an
odd-length indirect symbol table (4-byte entries), so stroff frequently lands on
a 4-aligned-but-not-8 offset. Neither linker pads it. This is a toolchain/OS-beta
mismatch, not a corrupt build.

Fix: insert N zero bytes (N = pad to reach 8 alignment) just before the string
table, bump LC_SYMTAB.stroff and the __LINKEDIT segment size, then re-sign
(ad-hoc) so the binary loads on Apple Silicon. n_strx values are offsets relative
to stroff, so moving the whole table as a block keeps every lookup valid.

Usage: align-linkedit.py <dylib> [<dylib> ...]
Idempotent: a dylib already 8-aligned is left untouched.
"""
import struct
import subprocess
import sys

MH_MAGIC_64 = 0xFEEDFACF
LC_SEGMENT_64 = 0x19
LC_SYMTAB = 0x02
PAGE = 0x4000  # arm64 page size


def roundup(v, a):
    return (v + a - 1) // a * a


def patch(path):
    with open(path, "rb") as f:
        data = bytearray(f.read())

    magic = struct.unpack_from("<I", data, 0)[0]
    if magic != MH_MAGIC_64:
        print(f"  skip {path}: not a thin 64-bit Mach-O (magic={magic:#x})")
        return False

    ncmds = struct.unpack_from("<I", data, 16)[0]
    off = 32  # mach_header_64 size

    symtab_off = None
    stroff = None
    linkedit_off = None  # file offset of the __LINKEDIT load command
    linkedit_fileoff = None

    for _ in range(ncmds):
        cmd, cmdsize = struct.unpack_from("<II", data, off)
        if cmd == LC_SYMTAB:
            symtab_off = off
            stroff = struct.unpack_from("<I", data, off + 16)[0]
        elif cmd == LC_SEGMENT_64:
            # segment_command_64: cmd0 cmdsize4 segname8 vmaddr24 vmsize32
            #                      fileoff40 filesize48
            segname = data[off + 8 : off + 24].split(b"\x00")[0]
            if segname == b"__LINKEDIT":
                linkedit_off = off
                linkedit_fileoff = struct.unpack_from("<Q", data, off + 40)[0]
        off += cmdsize

    if stroff is None or linkedit_off is None:
        print(f"  skip {path}: missing LC_SYMTAB or __LINKEDIT")
        return False

    pad = (8 - (stroff % 8)) % 8
    if pad == 0:
        print(f"  ok   {path}: stroff={stroff} already 8-aligned")
        return False

    # Drop any existing signature first; we re-sign after the edit anyway, and
    # this keeps the signature blob from sitting after the string table.
    subprocess.run(
        ["codesign", "--remove-signature", path],
        check=False, capture_output=True,
    )
    with open(path, "rb") as f:
        data = bytearray(f.read())
    # Re-resolve offsets (removing the signature can rewrite __LINKEDIT size,
    # but not stroff or the load-command offsets we captured).

    # Insert `pad` zero bytes just before the string table.
    new = data[:stroff] + bytearray(pad) + data[stroff:]

    # stroff moves forward by pad; strsize and every n_strx (relative) unchanged.
    struct.pack_into("<I", new, symtab_off + 16, stroff + pad)

    # __LINKEDIT now extends `pad` bytes further. Bump filesize; only grow the
    # (page-rounded) vmsize if the few extra bytes spilled past it.
    filesize = len(new) - linkedit_fileoff
    old_vmsize = struct.unpack_from("<Q", new, linkedit_off + 32)[0]
    vmsize = max(old_vmsize, roundup(filesize, PAGE))
    struct.pack_into("<Q", new, linkedit_off + 32, vmsize)    # vmsize
    struct.pack_into("<Q", new, linkedit_off + 48, filesize)  # filesize

    with open(path, "wb") as f:
        f.write(new)

    # Re-sign ad-hoc so Apple Silicon dyld will load it.
    r = subprocess.run(
        ["codesign", "-f", "-s", "-", path], capture_output=True, text=True
    )
    if r.returncode != 0:
        print(f"  FAIL {path}: codesign: {r.stderr.strip()}")
        return False

    print(f"  fix  {path}: stroff {stroff} -> {stroff + pad} (+{pad}), re-signed")
    return True


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    any_fail = False
    for p in sys.argv[1:]:
        try:
            patch(p)
        except Exception as e:  # noqa: BLE001
            print(f"  ERROR {p}: {e}")
            any_fail = True
    sys.exit(1 if any_fail else 0)
