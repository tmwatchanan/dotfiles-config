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

return M
