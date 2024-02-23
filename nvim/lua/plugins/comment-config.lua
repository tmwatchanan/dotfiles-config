local M = {
    'numToStr/Comment.nvim',
    dependencies = {
        { 'nvim-treesitter' },
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            opts = { enable_autocmd = false },
        },
    },
    lazy = false,
}

M.opts = {

}

M.keys = function()
    local comment_keymap = require('config.keymaps').comment
    vim.keymap.set('n', comment_keymap.toggler.line, function()
        return vim.api.nvim_get_vvar('count') == 0 and '<Plug>(comment_toggle_linewise_current)' or
            '<Plug>(comment_toggle_linewise_count)'
    end, { expr = true, desc = 'Comment toggle current line with lesser key strokes' })
end

return M
