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
    desc = 'assign q to quit when in diff mode',
    pattern = 'diff',
    callback = function() vim.keymap.set('n', 'q', '<c-w>h:q<cr>', { buffer = true }) end
})

-- check if we need to reload file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    command = 'checktime'
})

vim.api.nvim_create_autocmd({ 'CmdwinEnter' }, {
    pattern = '*',
    callback = function() vim.keymap.set('n', 'qq', '<C-w>c', { buffer = true }) end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'yaml',
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end
})
