local M = {
    'hiphish/rainbow-delimiters.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
}

M.config = function()
    vim.g.rainbow_delimiters = {
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        highlight = {
            'RainbowDelimiterCyan',
            'RainbowDelimiterViolet',
            'RainbowDelimiterGreen',
            'RainbowDelimiterOrange',
            'RainbowDelimiterBlue',
            'RainbowDelimiterYellow',
            'RainbowDelimiterRed',
        },
    }
end

return M
