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
    {
        'towolf/vim-helm',
        event = { 'BufReadPost', 'BufNewFile' },
        ft = 'helm',
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
    {
        'letieu/jot.lua',
        dependencies = 'plenary.nvim',
        config = function()
            local win_width = math.floor(vim.o.columns * 0.8)
            local win_height = math.floor(vim.o.lines * 0.8)

            require('jot').config = {
                quit_key = 'q',
                notes_dir = vim.fn.stdpath('data') .. '/jot',
                win_opts = {
                    relative = 'editor',
                    width = win_width,
                    height = win_height,
                    row = math.floor((vim.o.lines - win_height) / 2) - 1,
                    col = math.floor((vim.o.columns - win_width) / 2) - 1,
                    border = 'rounded',
                    title = ' Project Notes - ' .. vim.uv.cwd() .. ' ',
                    footer = ' press `q` to exit ',
                    footer_pos = 'right',
                }
            }
        end,
        keys = { { '<leader>n', function() require('jot').toggle() end } }
    }
}
