local M = {}

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

return M
