local M = {
    'numToStr/Comment.nvim',
    dependencies = {
        { 'nvim-treesitter' },
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            opts = { enable_autocmd = false },
        },
    },
    opts = {
    },
    lazy = false,
}

return M
