local M = {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
}

M.keys = function()
    local keymap = require('config.keymaps').diffview

    return {
        { keymap.open,         '<Cmd>DiffviewOpen<CR>' },
        { keymap.close,        '<Cmd>DiffviewClose<CR>' },
        { keymap.current_file, '<Cmd>DiffviewFileHistory %<CR>' },
        { keymap.file_history, '<Cmd>DiffviewFileHistory<CR>' },
        { keymap.toggle_files, '<Cmd>DiffviewToggleFiles<CR>' },
        { keymap.compare_head, '<Cmd>DiffviewOpen HEAD<CR>' },
    }
end

return M
