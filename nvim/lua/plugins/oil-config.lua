local M = {
    'MomePP/oil.nvim',
    dependencies = 'nvim-mini/mini.icons',
    cond = not vim.g.vscode,
}

M.opts = {
    columns = {
        'permissions',
        'size',
        'mtime',
        'icon',
    },
    view_options = {
        show_hidden = true,
    },
    delete_to_trash = true,
    float = {
        border = 'solid',
        override = function(conf)
            conf.width = vim.o.columns - 2 -- NOTE: this offset cause by padding = 2
            conf.height = vim.o.lines - 3
            conf.col = 0
            conf.row = 0
            return conf
        end,
        win_options = {
            winhighlight = 'Normal:NormalFloat,FloatTitle:OilTitle',
            winblend = vim.opt.winblend:get(),
        },
        get_win_title = function(_)
            return ''
        end,
        preview_split = 'right',
        preview_title_pos = 'center',
    },
    preview_win = {
        win_options = {
            winhighlight = 'Normal:OilPreviewNormal,FloatBorder:OilPreviewBorder,FloatTitle:OilPreviewTitle',
        },
    },
    keymaps = {
        ['<C-u>'] = 'actions.preview_scroll_up',
        ['<C-d>'] = 'actions.preview_scroll_down',
        ['<C-y>'] = 'actions.copy_to_system_clipboard',
        ['<C-p>'] = 'actions.paste_from_system_clipboard',
        ['<C-o>'] = {
            callback = function()
                local dir = require('oil').get_current_dir()
                if not dir or not vim.ui.open then
                    return
                end

                vim.ui.open(dir)
            end,
            desc = 'Reveal directory'
        },

        -- close
        ['<Esc>'] =  'actions.close',
        ['qq'] =  'actions.close',
        ['<leader><Tab>'] = 'actions.close',

        -- open tab
        ['<C-t>'] = false,

        -- open split
        ['<C-h>'] = false,
        ['<C-s>'] = 'actions.select_split',
        ['<C-v>'] = 'actions.select_vsplit',

        -- refresh
        ['<C-l>'] = false,
        ['<C-r>'] = 'actions.refresh',

        -- parent
        ['-'] = false,
        ['<BS>'] = 'actions.parent',

        -- trash
        ['gt'] = 'actions.toggle_trash',
    }
}

M.keys = function()
    local oil_keymap = require('config.keymaps').oil
    return {
        {
            oil_keymap.open_float,
            function()
                if vim.w.is_oil_win then
                    require('oil').close()
                else
                    require('oil').open_float(nil, { preview = {} })
                end
            end
        },
    }
end

return M
