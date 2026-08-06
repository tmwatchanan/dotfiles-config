local M = {}

--- Grep within a single directory.
---
--- Opens a fresh picker rather than calling `picker:set_cwd()`, because the
--- cwd-derived options - the submodule excludes in particular - are resolved when
--- the picker is created and would otherwise keep pointing at the old root.
---@param dir string? directory to search; nothing happens when it cannot be resolved
---@param search string? initial query, carried over when narrowing from another grep
function M.grep_in(dir, search)
    if not dir or dir == '' then
        vim.notify('No directory to grep', vim.log.levels.WARN)
        return
    end

    require('snacks').picker.grep({
        cwd = dir,
        hidden = true,
        search = search,
        title = ('Grep %s'):format(vim.fn.fnamemodify(dir, ':~:.')),
    })
end

--- Directory under the oil cursor, falling back to the one being browsed.
--- nil for remote adapters, where there is nothing for ripgrep to walk.
---@return string?
function M.oil_dir()
    local oil = require('oil')
    local dir = oil.get_current_dir()
    if not dir then return nil end

    local entry = oil.get_cursor_entry()
    if not entry or entry.type ~= 'directory' then return dir end

    -- normalized so the '..' entry resolves to the parent rather than a literal
    -- '<dir>/..' in the picker title
    return vim.fs.normalize(vim.fs.joinpath(dir, entry.name))
end

--- Pick a commit by sha or message, then diff it against its parent.
---
--- CodeDiff's explorer takes two revisions, so the parent is resolved here rather
--- than passed as `<sha>~`: the root commit has no parent and needs git's empty
--- tree as the left side instead.
function M.codediff_commit()
    require('snacks').picker.git_log({
        cmd_args = { '--abbrev=8' },
        confirm = function(picker, item)
            picker:close()
            if not item then return end

            local repo = item.cwd
            local function git(...)
                return vim.system({ 'git', '-C', repo, ... }):wait()
            end

            local parent = git('rev-parse', '--verify', '--quiet', item.commit .. '^')
            -- hashed rather than hardcoded, so sha256 repos work too
            local base = parent.code == 0 and parent.stdout
                or git('hash-object', '-t', 'tree', '/dev/null').stdout

            vim.cmd({ cmd = 'CodeDiff', args = { '--repo', repo, vim.trim(base), item.commit } })
        end,
    })
end

--- Directory of the neo-tree node under the cursor, or its parent for a file.
---@return string?
function M.neotree_dir(state)
    local node = state.tree:get_node()
    if not node then return nil end

    local path = node:get_id()
    return node.type == 'directory' and path or vim.fs.dirname(path)
end

return M
