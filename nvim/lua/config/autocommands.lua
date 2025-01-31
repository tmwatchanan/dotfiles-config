vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'turn off paste mode when leaving insert',
    pattern = '*',
    command = 'set nopaste'
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'open help docs in vertical split',
    pattern = 'help',
    command = ':wincmd L | :vert'
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'highlight text on yank',
    pattern = '*',
    callback = function() vim.highlight.on_yank {} end
})

vim.api.nvim_create_autocmd('OptionSet', {
    desc = 'assign q to quit when in diff mode',
    pattern = 'diff',
    callback = function() vim.keymap.set('n', 'q', '<c-w>h:q<cr>', { buffer = true }) end
})

-- check if we need to reload file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    command = 'checktime'
})

vim.api.nvim_create_autocmd('BufWritePost', {
    desc = 'update diagnostics when written buffer',
    callback = function() vim.diagnostic.show() end
})
