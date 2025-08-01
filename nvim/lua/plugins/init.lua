return {
    -- Core Dependencies
    { 'nvim-lua/plenary.nvim' },
    { 'MunifTanjim/nui.nvim' },
    {
        'echasnovski/mini.icons',
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
        opts = {
            lsp = {
                auto_attach = true,
                preference = { 'volar', 'jsonls' },
            },
        },
        cond = not vim.g.vscode,
    },
    {
        'Wansmer/treesj',
        dependencies = 'nvim-treesitter',
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            { require('config.keymaps').treesj.toggle, '<Cmd>TSJToggle<CR>' },
        }
    },
    {
        'Wansmer/sibling-swap.nvim',
        requires = { 'nvim-treesitter' },
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
    },
    {
        'andymass/vim-matchup',
        dependencies = 'nvim-treesitter',
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
        'MomePP/sentiment.nvim',
        event = 'VeryLazy',
        config = true,
    },
    {
        'axkirillov/hbac.nvim',
        opts = {
            threshold = 20,
            close_command = function(bufnr)
                local force = vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == 'terminal'
                pcall(require('snacks').bufdelete.delete, { buf = bufnr, force = force })
            end
        },
        keys = function()
            local hbac_keymap = require('config.keymaps').hbac
            return {
                { hbac_keymap.toggle_pin, '<Cmd>Hbac toggle_pin<CR>' }
            }
        end,
        cond = not vim.g.vscode,
    },
    {
        'saecki/live-rename.nvim',
        opts = true,
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
        'OXY2DEV/markview.nvim',
        dependencies = { 'nvim-treesitter', 'mini.icons' },
        ft = { 'markdown', 'codecompanion' },
        opts = function()
            local presets = require('markview.presets')
            return {
                preview = {
                    icon_provider = 'mini',
                    filetypes = { 'markdown', 'codecompanion' },
                    ignore_buftypes = {},
                },
                markdown = {
                    list_items = {
                        marker_minus = { add_padding = false },
                        marker_plus = { add_padding = false },
                        marker_star = { add_padding = false }
                    },
                    headings = presets.headings.glow,
                    horizontal_rules = presets.horizontal_rules.thick,
                },
                markdown_inline = {
                    checkboxes = presets.checkboxes.nerd,
                }
            }
        end,
    },
    {
        'letieu/jot.lua',
        dependencies = 'plenary.nvim',
        config = function()
            local win_width = math.floor(vim.o.columns * 0.8)
            local win_height = math.floor(vim.o.lines * 0.8)

            local function get_file_last_modified(file_path)
                local stat = vim.uv.fs_stat(file_path)
                if stat then
                    local last_modified = stat.mtime.sec
                    return ' Updated: ' .. os.date('%d-%b-%Y %H:%M', last_modified) .. ' '
                else
                    return ''
                end
            end

            require('jot').config = {
                quit_key = 'q',
                notes_dir = vim.fn.stdpath('data') .. '/jot',
                win_opts = {
                    relative = 'editor',
                    width = win_width,
                    height = win_height,
                    row = math.floor((vim.o.lines - win_height) / 2) - 1,
                    col = math.floor((vim.o.columns - win_width) / 2) - 1,
                    border = 'solid',
                    title = ' Project Notes - ' .. vim.uv.cwd() .. ' ',
                    footer = get_file_last_modified(vim.fn.expand('%:p')),
                    footer_pos = 'right',
                }
            }
        end,
        keys = function()
            local jot_keymap = require('config.keymaps').jot
            return {
                { jot_keymap.toggle, function() require('jot').toggle() end }
            }
        end,
        cond = not vim.g.vscode,
    }
}
