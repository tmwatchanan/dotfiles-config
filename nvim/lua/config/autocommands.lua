vim.api.nvim_create_autocmd('FileType', {
    desc = 'press <Enter> to jump to the location in help docs',
    pattern = 'help',
    callback = function() vim.keymap.set('n', '<CR>', '<C-]>', { buffer = true }) end
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'press <BS> to jump back in help docs',
    pattern = 'help',
    callback = function() vim.keymap.set('n', '<BS>', '<C-o>', { buffer = true }) end
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'press `qq` to exit help docs',
    pattern = 'help',
    callback = function() vim.keymap.set('n', 'qq', '<C-w>q', { buffer = true }) end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'highlight text on yank',
    pattern = '*',
    callback = function() vim.highlight.on_yank {} end
})

vim.api.nvim_create_autocmd('OptionSet', {
    desc = 'assign q to quit when in diff mode or Diffview',
    pattern = 'diff',
    callback = function()
        local diffview_status, _ = pcall(require, 'diffview')
        if diffview_status then
            vim.keymap.set('n', 'q', function() vim.cmd('DiffviewClose') end, { buffer = true })
        else
            vim.keymap.set('n', 'q', '<c-w>h:q<cr>', { buffer = true })
        end
    end
})

-- check if we need to reload file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    command = 'checktime'
})

vim.api.nvim_create_autocmd({ 'CmdwinEnter' }, {
    desc = '`qq` to close command-line window',
    pattern = '*',
    callback = function() vim.keymap.set('n', 'qq', '<C-w>c', { buffer = true }) end
})

vim.api.nvim_create_autocmd('BufWritePost', {
    desc = 'update diagnostics when written buffer',
    callback = function() vim.diagnostic.show() end
})
