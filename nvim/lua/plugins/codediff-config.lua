local M = {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    cond = not vim.g.vscode,
}

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
    }
end

return M
