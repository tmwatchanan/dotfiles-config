local del_qf_item = function()
    local items = vim.fn.getqflist()
    local line = vim.fn.line('.')
    table.remove(items, line)
    vim.fn.setqflist(items, 'r')

    items = vim.fn.getqflist()
    local cursor_line = line
    if cursor_line >= #items then
        cursor_line = #items
    end
    vim.api.nvim_win_set_cursor(0, { cursor_line, 0 })
end

vim.keymap.set('n', 'dd', del_qf_item, {
    silent = true,
    buffer = true,
    desc = 'Remove entry from QF',
})
vim.keymap.set('n', 'qq', ':cclose<CR>', {
    silent = true,
    buffer = true,
    desc = 'Close the quickfix window',
})
vim.keymap.set('n', 'cc', ':cdo %s/<C-r><C-f>//g<Left><Left>', {
    buffer = true,
    desc = 'Replace word under cursor for all files in quickfix',
})
vim.keymap.set('n', 'C', ':cdo %s///g<Left><Left><Left>', {
    buffer = true,
    desc = 'Replace string for all files in quickfix',
})
vim.keymap.set('n', 'cw', ':cdo update', {
    buffer = true,
    desc = 'Save all modified files in quickfix',
})
vim.keymap.set('n', 'cu', ':cdo norm! u', {
    buffer = true,
    desc = 'Undo the last modification based on the quickfix',
})
