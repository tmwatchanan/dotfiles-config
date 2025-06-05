local M = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-context',
            opts = { zindex = 5, max_lines = 3 },
        },
        {
            'folke/ts-comments.nvim',
            opts = true
        },
        'rainbow-delimiters.nvim',
        'indent-blankline.nvim',
    },
    main = 'nvim-treesitter.configs'
}

M.opts = {
    ensure_installed = {
        'regex',
        'lua',
        'vim',
        'vimdoc',
        'markdown',
        'markdown_inline',
        'bash',
        'nu',
        'yaml',
        'tsx',
        'javascript',
        'css',
        'scss',
        'latex',
    },
    ignore_install = {
        'norg',
        'vala'
    },
    auto_install = true,
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { 'cpp' }
    },
    incremental_selection = {
        enable = true,
        keymaps = require('config.keymaps').treesitter.incremental_selection,
    },
}

return M
