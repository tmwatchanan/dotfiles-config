local M = {
    'mg979/vim-visual-multi',
    lazy = false,
    -- cond = not vim.g.vscode,
}

M.init = function()
    vim.g.VM_default_mappings = 1
    vim.g.VM_mouse_mappings   = 1
end

-- M.config = function()
--     local vim_visual_multi_keymap = require('config.keymaps').vim_visual_multi
--     vim.keymap.set('n', vim_visual_multi_keymap.find_under, '<Plug>(VM-Find-Under)')
--     vim.keymap.set('x', vim_visual_multi_keymap.find_subword_under, '<Plug>(VM-Find-Subword-Under)')
-- end

return M
