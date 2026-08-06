local M = {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    cond = not vim.g.vscode,
}

local marked_path = nil

--- `:CodeDiff file` reads both sides from disk, so the mark is a path, not a buffer
local function buffer_path()
    if vim.bo.buftype ~= '' then return nil end

    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then return nil end

    return vim.fn.fnamemodify(name, ':p')
end

local function relative(path)
    return vim.fn.fnamemodify(path, ':~:.')
end

-- `bufnr()` treats its argument as a pattern, so match names exactly instead
local function warn_if_unsaved(path)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == path and vim.bo[buf].modified then
            vim.notify(('codediff: %s has unsaved changes, diffing the version on disk'):format(relative(path)),
                vim.log.levels.WARN)
            return
        end
    end
end

local function mark_for_compare()
    local path = buffer_path()
    if not path then
        return vim.notify('codediff: current buffer is not a file', vim.log.levels.WARN)
    end

    marked_path = path
    vim.notify(('codediff: marked %s'):format(relative(path)))
end

--- The mark is kept so one file can be compared against several others in a row
local function compare_with_mark()
    if not marked_path then
        return vim.notify('codediff: nothing marked yet', vim.log.levels.WARN)
    end

    local path = buffer_path()
    if not path then
        return vim.notify('codediff: current buffer is not a file', vim.log.levels.WARN)
    end
    if path == marked_path then
        return vim.notify('codediff: current buffer is the marked file', vim.log.levels.WARN)
    end

    warn_if_unsaved(marked_path)
    warn_if_unsaved(path)

    vim.cmd({ cmd = 'CodeDiff', args = { 'file', marked_path, path } })
end

M.opts = function()
    local keymap = require('config.keymaps').codediff

    return {
        -- the explorer has no 'top' position; 'bottom' keeps the horizontal panel
        explorer = {
            position = 'bottom',
            height = 10,
        },
        keymaps = {
            view = {
                toggle_explorer = keymap.toggle_files,
            },
        },
    }
end

M.keys = function()
    local keymap = require('config.keymaps').codediff

    return {
        -- `:CodeDiff` closes the session when run from its own tab, so this toggles
        { keymap.open,          '<Cmd>CodeDiff<CR>' },
        { keymap.current_file,  '<Cmd>CodeDiff history %<CR>' },
        { keymap.file_history,  '<Cmd>CodeDiff history<CR>' },
        { keymap.compare_head,  '<Cmd>CodeDiff HEAD<CR>' },
        { keymap.commit,        function() require('config.pickers').codediff_commit() end },
        { keymap.review_branch, ':CodeDiff origin/develop...' },
        { keymap.merge_request, ':CodeDiff mr-origin-' },
        { keymap.mark,          mark_for_compare },
        { keymap.compare_mark,  compare_with_mark },
    }
end

return M
