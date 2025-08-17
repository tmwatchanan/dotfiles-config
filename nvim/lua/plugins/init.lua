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
    },

    -- Utilities
    {
        'nmac427/guess-indent.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = true
    },
    {
        'echasnovski/mini.surround',
        main = 'mini.surround',
        event = 'VeryLazy',
        config = true
    },
    {
        'echasnovski/mini.diff',
        main = 'mini.diff',
        event = 'VeryLazy',
        opts = function()
            local diff_keymap = require('config.keymaps').diff
            return {
                view = {
                    style = 'sign',
                    signs = { add = '┃', change = '┃', delete = '┃' },
                },
                options = { wrap_goto = true },
                mappings = {
                    -- Apply / Reset hunks inside a visual/operator region
                    apply = diff_keymap.apply_hunk,
                    reset = diff_keymap.reset_hunk,

                    -- Hunk range textobject to be used inside operator
                    textobject = diff_keymap.text_object,

                    -- Go to hunk range in corresponding direction
                    goto_first = diff_keymap.first_hunk,
                    goto_prev = diff_keymap.prev_hunk,
                    goto_next = diff_keymap.next_hunk,
                    goto_last = diff_keymap.last_hunk,
                }
            }
        end,
        keys = function()
            local diff_keymap = require('config.keymaps').diff
            return {
                {
                    diff_keymap.preview_hunk,
                    function() require('mini.diff').toggle_overlay() end,
                },
                {
                    diff_keymap.stage_hunk,
                    function() return require('mini.diff').operator('apply') .. diff_keymap.text_object end,
                    expr = true,
                    remap = true
                },
                {
                    diff_keymap.discard_hunk,
                    function() return require('mini.diff').operator('reset') .. diff_keymap.text_object end,
                    expr = true,
                    remap = true
                }
            }
        end
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
