local M = {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    cmd = 'DiffviewOpen',
}

M.opts = {
    default_args = {
        DiffviewOpen = { '--imply-local' },
    },
    file_panel = {
        win_config = {
            position = 'top',
            height = 10,
        },
    },
}

local toggle_diffview = function()
    if next(require('diffview.lib').views) == nil then
        vim.cmd('DiffviewOpen')
    else
        vim.cmd('DiffviewClose')
    end
end

M.keys = function()
    local keymap = require('config.keymaps').diffview

    return {
        { keymap.open,          toggle_diffview },
        { keymap.close,         '<Cmd>DiffviewClose<CR>' },
        { keymap.current_file,  '<Cmd>DiffviewFileHistory %<CR>' },
        { keymap.file_history,  '<Cmd>DiffviewFileHistory<CR>' },
        { keymap.toggle_files,  '<Cmd>DiffviewToggleFiles<CR>' },
        { keymap.compare_head,  '<Cmd>DiffviewOpen HEAD<CR>' },
        { keymap.review_branch, ':DiffviewOpen origin/develop...' },
        { keymap.merge_request, ':DiffviewOpen mr-origin-' },
    }
end

return M
