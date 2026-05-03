return {
    -- Core Dependencies
    { 'nvim-lua/plenary.nvim' },
    { 'MunifTanjim/nui.nvim' },
    {
        'nvim-mini/mini.icons',
        opts = {},
        init = function()
            package.preload['nvim-web-devicons'] = function()
                require('mini.icons').mock_nvim_web_devicons()
                return package.loaded['nvim-web-devicons']
            end
        end,
        cond = not vim.g.vscode,
    },

    -- Neovim config dev
    {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
        cond = not vim.g.vscode,
    },
    {
        'Bilal2453/luvit-meta',
        lazy = true,
        ft = 'lua',
    }, -- optional `vim.uv` typings

    -- Utilities
    {
        'nmac427/guess-indent.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        cond = not vim.g.vscode,
    },
    {
        'kylechui/nvim-surround',
        event = 'VeryLazy',
        opts = {
            highlight = {
                duration = 1000,
            },
        }
    },
    {
        'SmiteshP/nvim-navic',
        cond = not vim.g.vscode,
        opts = {
            lsp = {
                auto_attach = true,
                preference = { 'volar', 'jsonls' },
            },
        },
    },
    {
        'Wansmer/treesj',
        dependencies = 'neovim-treesitter/nvim-treesitter',
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            { require('config.keymaps').treesj.toggle, '<Cmd>TSJToggle<CR>' },
        }
    },
    {
        'Wansmer/sibling-swap.nvim',
        requires = { 'neovim-treesitter/nvim-treesitter' },
        opts = {
            highlight_node_at_cursor = true,
        },
        keys = {
            -- (`<C-,>` and `<C-.>` may not map to control chars at system level, so are sent by certain terminals as just `,` and `.`. In this case, just add the mappings you want.)
            { '<C-.>' },
            { '<C-,>' },
            { '<leader>.' },
            { '<leader>,' },
        },
    },
    {
        'towolf/vim-helm',
        ft = 'helm',
        cond = not vim.g.vscode,
    },
    {
        'andymass/vim-matchup',
        dependencies = 'neovim-treesitter/nvim-treesitter',
        lazy = false,
        init = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
            if vim.g.vscode then
                -- NOTE: there's a bug associated with this option when exit insert mode
                -- the typed text will be replicated
                vim.g.matchup_matchparen_enabled = 0
            end
        end,
    },
    {
        'serhez/bento.nvim',
        event = 'VeryLazy',
        cond = not vim.g.vscode,
        opts = {
            max_open_buffers = 20,
            ui = {
                floating = {
                    max_rendered_buffers = 10,
                }
            },
            lock_char = require('config').defaults.icons.bento.pinned,
        },
    },
    {
        'saecki/live-rename.nvim',
        config = true,
        cond = not vim.g.vscode,
        keys = function()
            local rename_keymap = require('config.keymaps').rename
            return {
                { rename_keymap.rename,       function() require('live-rename').rename({ insert = true }) end },
                { rename_keymap.rename_clean, function() require('live-rename').rename({ text = '', insert = true }) end },
            }
        end
    },

    -- Miscellaneous
    {
        'RaafatTurki/hex.nvim',
        cmd = { 'HexToggle', 'HexDump', 'HexAssemble' },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'neovim-treesitter/nvim-treesitter',
            'nvim-mini/mini.icons',
        },
        event = 'VeryLazy',
        cond = not vim.g.vscode,
        opts = {
            file_types = { 'markdown', 'codecompanion' },
            anti_conceal = {
                enabled = false,
            },
            code = {
                position = 'right',
                width = 'block',
                border = 'thick',
                left_pad = 2,
                right_pad = 2,
            },
            pipe_table = {
                preset = 'round'
            },
            overrides = {
                filetype = {
                    codecompanion = {
                        render_modes = { 'n', 'c', 'v' },
                    },
                },
            },
        }
    },
}
