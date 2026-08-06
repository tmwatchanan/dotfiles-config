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
    callback = function() vim.hl.hl_op() end
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    desc = 'press `q` on either side of a gitsigns diff to close it',
    pattern = 'gitsigns://*',
    callback = function(event)
        local diff_buf = event.buf
        local diff_win = vim.api.nvim_get_current_win()

        local function close_diff()
            if vim.api.nvim_win_is_valid(diff_win) then
                vim.api.nvim_win_close(diff_win, false)
            end
        end

        vim.keymap.set('n', 'q', close_diff, { buffer = diff_buf, silent = true })

        -- `gitsigns.diffthis` returns the cursor to the source window, so `q` has to work
        -- there too; `diff` is only set once `:diffsplit` returns, hence the deferral
        vim.schedule(function()
            if not vim.api.nvim_win_is_valid(diff_win) then return end

            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if win ~= diff_win and vim.wo[win].diff then
                    local source_buf = vim.api.nvim_win_get_buf(win)

                    vim.keymap.set('n', 'q', close_diff, { buffer = source_buf, silent = true })
                    -- give `q` back to macro recording afterwards; the diff buffer sets
                    -- 'bufhidden' to wipe, so it is wiped rather than hidden on close
                    vim.api.nvim_create_autocmd('BufWipeout', {
                        buffer = diff_buf,
                        once = true,
                        callback = function()
                            pcall(vim.keymap.del, 'n', 'q', { buffer = source_buf })
                        end
                    })
                end
            end
        end)
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
    callback = function(args)
        if vim.api.nvim_buf_is_valid(args.buf) then
            vim.diagnostic.show(nil, args.buf)
        end
    end
})

-- close window with q
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'help',
        'qf',
        'nvim-pack',
        'checkhealth',
    },
    callback = function(event)
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end
})
