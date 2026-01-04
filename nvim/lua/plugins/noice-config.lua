local M = {
    'folke/noice.nvim',
    lazy = false,
    cond = not vim.g.vscode,
}

M.opts = {
    views = {
        hover = {
            focusable = false,
            border = {
                style = 'none',
                padding = { 1, 2 },
            },
            position = { row = 2, col = 0 },
            win_options = {
                wrap = true,
                linebreak = true,
                winblend = 10,
                winhighlight = { Normal = 'Pmenu', FloatBorder = 'Pmenu', Search = 'NONE' }
            },
        },
        confirm = {
            backend = 'popup',
            position = {
                row = '100%',
                col = 0,
            },
            size = {
                height = 'auto',
                width = '100%',
            },
            format = { ' {confirm}' },
        },
        mini = {
            win_options = { winblend = 0 },
            timeout = 5000,
        },
        cmdline = {
            win_options = { winblend = 0 },
        },
        split = {
            size = '30%'
        },
        popup = {
            border = {
                style = 'solid',
            },
        },
    },
    messages = {
        view_search = false,
    },
    cmdline = {
        view = 'cmdline',
        format = {
            cmdline = { icon = ' COMMAND ' },
            search_down = { icon = ' Search  ' },
            search_up = { icon = ' Search  ' },
            calculator = { icon = ' Calculator ', icon_hl_group = 'NoiceCmdlineIconFilter' },
            help = { icon = ' Help   ' },
            input = { view = 'cmdline' },
            lua = { icon = ' Lua  '},
        }
    },
    popupmenu = {
        enabled = true,
    },
    commands = {
        history = {
            opts = {
                format = {
                    '{date} ',
                    '{event}', { '{kind} ', before = { '.', hl_group = 'NoiceFormatKind' } },
                    '{title} ',
                    '{cmdline}',
                    '\n',
                    '{level} ',
                    '{message}\n',
                },
            },
            filter_opts = { reverse = true },
            filter = {
                any = {
                    { warning = true },
                    { error = true },
                    { event = 'notify' },
                    { event = 'msg_show' },
                    { event = 'lsp',     kind = 'message' },
                },
            },
        }
    },
    lsp = {
        progress = { enabled = false },
        hover = { enabled = true, },
        signature = { enabled = true },
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
        }
    },
}

M.keys = function()
    local noice_keymaps = require('config.keymaps').noice

    return {
        { noice_keymaps.history, '<Cmd>Noice<CR>' },
        {
            noice_keymaps.docs_scroll_down,
            function()
                if not require('noice.lsp').scroll(4) then
                    local keys = vim.api.nvim_replace_termcodes(noice_keymaps.docs_scroll_down, true, true, true)
                    vim.api.nvim_feedkeys(keys, 'n', false)
                end
            end,
        },
        {
            noice_keymaps.docs_scroll_up,
            function()
                if not require('noice.lsp').scroll(-4) then
                    local keys = vim.api.nvim_replace_termcodes(noice_keymaps.docs_scroll_up, true, true, true)
                    vim.api.nvim_feedkeys(keys, 'n', false)
                end
            end,
        },
    }
end

return M
