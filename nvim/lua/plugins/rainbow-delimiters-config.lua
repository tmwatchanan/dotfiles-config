local M = {
    'hiphish/rainbow-delimiters.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'rainbow-delimiters.setup',
    cond = not vim.g.vscode,
}

M.opts = {
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
}

return M
