return {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'MunifTanjim/nui.nvim' },

    -- Neovim config dev
    {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
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
        'folke/ts-comments.nvim',
        event = 'VeryLazy',
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
            -- (`<C-,>` and `<C-.>` may not map to control chars at system level, so are sent by certain terminals as just `,` and `.`. In this case, just add the mappings you want.)
            keymaps = {
                ['<C-.>'] = false,
                ['<C-,>'] = false,
                ['<leader>.'] = 'swap_with_right_with_opp',
                ['<leader>,'] = 'swap_with_left_with_opp',
            },
        },
        keys = {
            { '<leader>.', mode = 'n' },
            { '<leader>,', mode = 'n' },
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
        end
    },

    -- Miscellaneous
    {
        'RaafatTurki/hex.nvim',
        cmd = { 'HexToggle', 'HexDump', 'HexAssemble' },
    },
    {
        'OXY2DEV/markview.nvim',
        dependencies = { 'nvim-treesitter', 'nvim-web-devicons' },
        ft = 'markdown',
        opts = {
            list_items = { shift_width = 2, indent_size = 2 }
        }
    },
    {
        'letieu/jot.lua',
        dependencies = 'plenary.nvim',
        config = function()
            local win_width = math.floor(vim.o.columns * 0.8)
            local win_height = math.floor(vim.o.lines * 0.8)

            local function get_file_last_modified(file_path)
                local stat = vim.loop.fs_stat(file_path)
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
