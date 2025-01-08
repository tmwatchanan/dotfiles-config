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
    },

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
    {
        'echasnovski/mini.pairs',
        event = { 'InsertEnter', 'CmdlineEnter' },
        opts = true
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
        config = true,
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
        keys = { { '<leader>n', function() require('jot').toggle() end } }
    }
}
