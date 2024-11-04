local M = {
    'hiphish/rainbow-delimiters.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'rainbow-delimiters.setup'
}

M.opts = {
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
}

return M
