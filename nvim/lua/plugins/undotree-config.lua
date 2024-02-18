local M = {
    'mbbill/undotree',
    lazy = false,
}

M.keys = function()
    local keymap = require('config.keymaps').undotree
    return {
        { keymap.open, "<Cmd>UndotreeToggle<CR>" },
    }
end

M.config = function()
    vim.g.undotree_WindowLayout = 4
    vim.g.undotree_SetFocusWhenToggle = true
end

return M
