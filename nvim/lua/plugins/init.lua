return {
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
        'utilyre/sentiment.nvim',
        version = '*',
        event = 'VeryLazy',
        init = function()
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end,
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
        end,
        cond = not vim.g.vscode,
    },
    {
        'echasnovski/mini.pairs',
        event = { 'InsertEnter', 'CmdlineEnter' },
        opts = true,
        enabled = false,
    },
    {
        'saecki/live-rename.nvim',
        opts = {},
        keys = function()
            local rename_keymap = require('config.keymaps').rename
            local live_rename = require('live-rename')

            return {
                { rename_keymap.rename,       live_rename.map({ insert = true }) },
                { rename_keymap.rename_clean, live_rename.map({ text = '', insert = true }) },
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
        ft = 'markdown',
        opts = function()
            local presets = require('markview.presets')
            return {
                highlight_groups = {
                    {
                        group_name = "Heading1",
                        value = { fg = "#FF186D", bg = "#581F34" }
                    },
                    {
                        group_name = "Heading2",
                        value = { fg = "#FF9B00", bg = "#583321" }
                    },
                    {
                        group_name = "Heading3",
                        value = { fg = "#FFE100", bg = "#584A21" }
                    },
                    {
                        group_name = "Heading4",
                        value = { fg = "#42FF00", bg = "#255131" }
                    },
                    {
                        group_name = "Heading5",
                        value = { fg = "#00FFC9", bg = "#1D5150" }
                    },
                    {
                        group_name = "Heading6",
                        value = { fg = "#9000FF", bg = "#2C1F58" }
                    },
                },
                list_items = { shift_width = 2, indent_size = 2 },
                code_blocks = { icon = 'mini' },
                checkboxes = presets.checkboxes.nerd,
                headings = presets.headings.glow
            }
        end
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
                notes_dir = vim.fn.stdpath('data') .. '/jot',
                win_opts = {
                    relative = 'editor',
                    width = win_width,
                    height = win_height,
                    row = math.floor((vim.o.lines - win_height) / 2) - 1,
                    col = math.floor((vim.o.columns - win_width) / 2) - 1,
                    border = 'rounded',
                    title = ' Project Notes - ' .. vim.uv.cwd() .. ' ',
                    footer = get_file_last_modified(vim.fn.expand('%:p')),
                    footer_pos = 'right',
                }
            }
        end,
        keys = { { '<leader>jn', function() require('jot').toggle() end } }
    }
}
