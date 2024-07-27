return {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
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
        'folke/ts-comments.nvim',
        event = 'VeryLazy',
        config = true
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
        config = true
    },
    {
        'utilyre/sentiment.nvim',
        event = 'VeryLazy',
        config = true
    },
    {
        'axkirillov/hbac.nvim',
        opts = {
            threshold = 20,
            close_command = function(bufnr)
                local force = vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == 'terminal'
                require('lazy').load({ plugins = { 'mini.bufremove' } })
                pcall(require('mini.bufremove').delete, bufnr, force)
            end
        },
        keys = function()
            local hbac_keymap = require('config.keymaps').hbac
            local hbac = require('hbac')

            return {
                { hbac_keymap.toggle_pin, hbac.toggle_pin }
            }
        end
    },

    -- Miscellaneous
    {
        'RaafatTurki/hex.nvim',
        cmd = { 'HexToggle', 'HexDump', 'HexAssemble' },
        config = true,
    },
    {
        'MeanderingProgrammer/markdown.nvim',
        dependencies = { 'nvim-treesitter', 'nvim-web-devicons' },
        ft = 'markdown',
        opts = {
            code = { left_pad = 2, border = 'thick' }
        }
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
