local noice_status, noice = pcall(require, 'noice')
if not noice_status then return end

local colors = require('colorscheme').colorset

-- override highlight group for Noice cmdline
vim.api.nvim_set_hl(0, 'NoiceCmdlineIconCmdline', { bg = colors.transparent, fg = colors.red, bold = true })
vim.api.nvim_set_hl(0, 'NoiceCmdlineIconSearch', { bg = colors.transparent, fg = colors.orange, bold = true })
vim.api.nvim_set_hl(0, 'NoiceCmdlineIconFilter', { bg = colors.transparent, fg = colors.teal, bold = true })

noice.setup {
    views = {
        mini = {
            focusable = false,
            timeout = 3000,
        },
    },
    messages = {
        view_search = false,
    },
    cmdline = {
        view = 'cmdline',
        format = {
            cmdline = { pattern = '^:', icon = ' COMMAND ' },
            search_down = { kind = 'search', pattern = '^/', icon = ' SEARCH  ', ft = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' SEARCH  ', ft = 'regex' },
            filter = { pattern = '^:%s*!', icon = ' TERMINAL ', opts = { buf_options = { filetype = 'sh' } } },
            lua = false,
        }
    },
    popupmenu = {
        backend = 'cmp',
    },
    routes = {
        {
            filter = {
                event = 'notify',
                warning = true,
                find = 'warning: multiple different client offset_encodings detected for buffer'
            },
            opts = { skip = true },
        },
    }
}
