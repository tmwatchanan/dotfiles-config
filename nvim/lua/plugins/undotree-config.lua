local M = {
    'mbbill/undotree',
    lazy = false,
    cond = not vim.g.vscode,
}

M.keys = function()
    local keymap = require('config.keymaps').undotree
    return {
        { keymap.open, "<Cmd>UndotreeToggle<CR>" },
    }
end

M.init = function()
    vim.g.undotree_WindowLayout = 4
    vim.g.undotree_SetFocusWhenToggle = false
end

return M
