local M = {
    'folke/noice.nvim',
    event = 'UIEnter',
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
            border = {
                style = 'none',
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
        }
    },
    messages = {
        view_search = false,
    },
    cmdline = {
        view = 'cmdline',
        format = {
            cmdline = { icon = ' COMMAND  ' },
            search_down = { icon = ' SEARCH  ' },
            search_up = { icon = ' SEARCH  ' },
            filter = { icon = ' TERMINAL ', lang = 'fish' },
            calculator = { icon = ' CALCULATOR ', icon_hl_group = 'NoiceCmdlineIconFilter' },
            help = { icon = ' HELP  ' },
            input = { view = 'cmdline' },
            lua = { icon = ' Lua  '},
        }
    },
    popupmenu = {
        enabled = true,
    },
    commands = {
        history = {
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
            ['cmp.entry.get_documentation'] = true,
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
                    return noice_keymaps.docs_scroll_down
                end
            end,
            silent = true,
            expr = true,
        },
        {
            noice_keymaps.docs_scroll_up,
            function()
                if not require('noice.lsp').scroll(-4) then
                    return noice_keymaps.docs_scroll_up
                end
            end,
            silent = true,
            expr = true,
        },
    }
end

return M
