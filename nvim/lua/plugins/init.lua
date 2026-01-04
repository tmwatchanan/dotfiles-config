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
    },

    -- Utilities
    {
        'nmac427/guess-indent.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = true
    },
    {
        'nvim-mini/mini.surround',
        main = 'mini.surround',
        event = 'VeryLazy',
        config = true
    },
    {
        'Wansmer/treesj',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            { require('config.keymaps').treesj.toggle, '<Cmd>TSJToggle<CR>' },
        }
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
        keys = {
            { require('config.keymaps').hbac.toggle_pin, '<Cmd>Hbac toggle_pin<CR>' }
        }
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
        config = true,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-mini/mini.icons',
        },
        ft = { 'markdown', 'codecompanion' },
        opts = {
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
    {
        'letieu/jot.lua',
        dependencies = 'nvim-lua/plenary.nvim',
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
        end
    }
}
