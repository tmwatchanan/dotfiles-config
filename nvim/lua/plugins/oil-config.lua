local M = {
    'MomePP/oil.nvim',
    dependencies = { 'echasnovski/mini.icons' },
}

M.opts = {
    columns = {
        'permissions',
        'size',
        'icon',
    },
    view_options = {
        show_hidden = true,
    },
    float = {
        border = 'solid',
        max_width = 0.85,
        max_height = 0.79, -- to equalize to snacks float win height
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
        ['<Space>'] = 'actions.close',
        ['q'] = 'actions.close',
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
    }
}

M.keys = function()
    local oil = require('oil')
    local oil_keymap = require('config.keymaps').oil

    return {
        {
            oil_keymap.open_float,
            function()
                if vim.w.is_oil_win then
                    oil.close()
                else
                    oil.open_float(nil, { preview = {} })
                end
            end
        },
    }
end

return M
