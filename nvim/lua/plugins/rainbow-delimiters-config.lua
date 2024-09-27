local M = {
    'hiphish/rainbow-delimiters.nvim',
    branch = 'fix-highlighting',
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
