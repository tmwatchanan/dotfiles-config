local M = {
    'nvim-focus/focus.nvim',
    event = 'UIEnter'
}

M.init = function()
    local ignore_buftypes = { 'nofile', 'prompt', 'popup', 'terminal' }
    local ignore_filetypes = { 'undotree' }
    local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

    vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
            if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
            then
                vim.w.focus_disable = true
            else
                vim.w.focus_disable = false
            end
        end,
        desc = 'Disable focus autoresize for BufType',
    })

    vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function()
            if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                vim.api.nvim_win_set_width(0, 40)
                vim.b.focus_disable = true
            end
        end,
        desc = 'Disable focus autoresize for FileType',
    })

    local dapui_filetypes = { 'dapui_breakpoints', 'dap-repl', 'dapui_console', 'dapui_scopes', 'dapui_watches', 'dapui_stacks' }
    local focus_keymaps = require('config.keymaps').focus
    vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function()
            if vim.tbl_contains(dapui_filetypes, vim.bo.filetype) then
                vim.keymap.set('n', focus_keymaps.split_left, '<C-w><C-h>', { buffer = true, desc = "focus left" })
                vim.keymap.set('n', focus_keymaps.split_right, '<C-w><C-l>', { buffer = true, desc = "focus right" })
                vim.keymap.set('n', focus_keymaps.split_up, '<C-w><C-k>', { buffer = true, desc = "focus up" })
                vim.keymap.set('n', focus_keymaps.split_down, '<C-w><C-j>', { buffer = true, desc = "focus down" })
            end
        end,
        desc = 'Disable focus autoresize for FileType',
    })
end

M.opts = {
    ui = { signcolumn = false }
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
