return {
    { 'nvim-lua/plenary.nvim' },
    { 'DaikyXendo/nvim-web-devicons' },
    { 'MunifTanjim/nui.nvim' },

    -- Utilities
    {
        'nmac427/guess-indent.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = true
    },
    {
        'kylechui/nvim-surround',
        event = 'VeryLazy',
        config = true,
        opts = {
            highlight = {
                duration = 1000,
            },
        }
    },
    {
        'SmiteshP/nvim-navic',
        opts = {
            lsp = {
                auto_attach = true,
                preference = { 'volar', 'jsonls' },
            },
        },
    },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter' },
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            { require('config.keymaps').treesj.toggle, '<Cmd>TSJToggle<CR>' },
        }
    },
    {
        'chrishrb/gx.nvim',
        dependencies = { 'plenary.nvim' },
        keys = { { 'gx', function() require('gx').open() end, mode = { 'n', 'x' } } },
        config = true,
    },
    {
        'utilyre/sentiment.nvim',
        event = 'VeryLazy',
        config = true
    },
    {
        'Wansmer/sibling-swap.nvim',
        requires = { 'nvim-treesitter' },
        event = { 'BufReadPost', 'BufNewFile' },
        config = true,
    },
    {
        'folke/neodev.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {},
    },

    -- Miscellaneous
    {
        'RaafatTurki/hex.nvim',
        cmd = { 'HexToggle', 'HexDump', 'HexAssemble' },
        config = true,
    },
    {
        'MeanderingProgrammer/markdown.nvim',
        dependencies = 'nvim-treesitter',
        ft = 'markdown',
        config = true,
    },
}
