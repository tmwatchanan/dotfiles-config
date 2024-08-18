local M = {
    'smjonas/inc-rename.nvim',
    opts = {
        input_buffer_type = 'dressing',
    },
}

M.keys = function()
    local keymap = require('config.keymaps').inc_rename
    return {
        { keymap.rename_current_word, function() return ':IncRename ' .. vim.fn.expand('<cword>') end, expr = true, desc = '[inc-rename.nvim] rename current word' },
        { keymap.rename_empty,        function() return ':IncRename ' end,                             expr = true, desc = '[inc-rename.nvim] rename current word, starting with empty' },
    }
end

return M
