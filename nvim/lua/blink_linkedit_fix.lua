-- Work around a macOS 27 (Darwin 27) dyld regression: it rejects any arm64
-- dylib whose LC_SYMTAB string pool is not 8-byte aligned, failing with
-- "mis-aligned LINKEDIT string pool, fileOffset=0x...". Rust + Apple ld (and
-- lld) routinely emit a 4-aligned pool, so blink's freshly built fuzzy/parser
-- native libs fail to load. This re-aligns + ad-hoc re-signs every dylib under
-- the plugin's lib/ directory after each build.
--
-- Drop this (and scripts/align-linkedit.py, and the build-hook calls) once a
-- macOS seed ships a dyld that accepts 4-aligned string pools again.
return function(plugin)
    if vim.fn.has('mac') == 0 then
        return
    end
    local script = vim.fn.expand('~/.config/nvim/scripts/align-linkedit.py')
    if vim.fn.filereadable(script) == 0 then
        return
    end
    -- Match pack/<name>/opt|start/<plugin>/lib regardless of pack name.
    local pattern = vim.fn.stdpath('data')
        .. '/site/pack/*/*/' .. plugin .. '/lib/*.dylib*'
    for _, f in ipairs(vim.fn.glob(pattern, false, true)) do
        local out = vim.fn.system({ 'python3', script, f })
        if vim.v.shell_error ~= 0 then
            vim.notify(
                'align-linkedit failed for ' .. f .. ': ' .. out,
                vim.log.levels.WARN
            )
        end
    end
end
