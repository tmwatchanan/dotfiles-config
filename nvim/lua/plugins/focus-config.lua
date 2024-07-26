local M = {
    'nvim-focus/focus.nvim',
    event = 'VeryLazy',
}

M.init = function()
    local ignore_buftypes = { 'nofile', 'prompt', 'popup', 'terminal' }
    local ignore_extension_filetypes = { 'undotree', 'neotest-summary' }
    local dapui_filetypes = { 'dapui_breakpoints', 'dap-repl', 'dapui_console', 'dapui_scopes', 'dapui_watches', 'dapui_stacks' }
    local filetype_sizes = {
        ['undotree'] = { width = 40 },
        ['neotest-summary'] = { width = 40 },
        ['neotest-output-panel'] = { height = 15 },
    }
    local ignore_filetypes = vim.tbl_extend('keep', ignore_extension_filetypes, dapui_filetypes)

    local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })
    vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function()
            if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
                vim.w.focus_disable = true
            -- else
            --     vim.w.focus_disable = false
            end
        end,
        desc = 'Disable focus autoresize for BufType',
    })
    vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function()
            if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                local focus_keymaps = require('config.keymaps').focus
                vim.keymap.set('n', focus_keymaps.split_left, '<C-w><C-h>', { buffer = true, desc = 'focus left' })
                vim.keymap.set('n', focus_keymaps.split_right, '<C-w><C-l>', { buffer = true, desc = 'focus right' })
                vim.keymap.set('n', focus_keymaps.split_up, '<C-w><C-k>', { buffer = true, desc = 'focus up' })
                vim.keymap.set('n', focus_keymaps.split_down, '<C-w><C-j>', { buffer = true, desc = 'focus down' })
                vim.b.focus_disable = true
            -- else
            --     vim.b.focus_disable = false
            end

            local size = filetype_sizes[vim.bo.filetype]
            if size then
                if size.width then
                    vim.api.nvim_win_set_width(0, size.width)
                end
                if size.height then
                    vim.api.nvim_win_set_height(0, size.height)
                end
                vim.b.focus_disable = true
            end
        end,
        desc = 'Disable focus autoresize for FileType',
    })
end

M.opts = {
    autoresize = {
        minwidth = 30,
        minheight = 10,
    },
    ui = {
        signcolumn = false,
    }
}

M.keys = function()
    local focus_keymaps = require('config.keymaps').focus

    return {
        { focus_keymaps.toggle_enable, '<Cmd>FocusToggle<CR>' },
        { focus_keymaps.toggle_size,   '<Cmd>FocusMaxOrEqual<CR>' },
        { focus_keymaps.split_cycle,   '<Cmd>FocusSplitCycle<CR>' },
        { focus_keymaps.split_left,    '<Cmd>FocusSplitLeft<CR>' },
        { focus_keymaps.split_right,   '<Cmd>FocusSplitRight<CR>' },
        { focus_keymaps.split_up,      '<Cmd>FocusSplitUp<CR>' },
        { focus_keymaps.split_down,    '<Cmd>FocusSplitDown<CR>' },
    }
end

return M
