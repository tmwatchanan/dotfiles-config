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
        config = true
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
        keys = { {
            'gx',
            function()
                require('gx').open()
                vim.defer_fn(function() vim.fn.jobstart('yabai -m space --balance') end, 300)
            end,
            mode = { 'n', 'x' },
        } },
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
        'rhysd/clever-f.vim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            vim.g.clever_f_fix_key_direction = 1
            -- vim.g.clever_f_mark_direct = 1
        end,
        keys = {
            { mode = 'n', '<Space>', '<Plug>(clever-f-reset)' },
            { mode = 'n', ';',       '<Plug>(clever-f-repeat-forward)' },
            { mode = 'n', ',',       '<Plug>(clever-f-repeat-back)' },
        },
    },

    -- Miscellaneous
    { 'RaafatTurki/hex.nvim', cmd = { 'HexToggle', 'HexDump', 'HexAssemble' }, config = true },
}
