local utils = require('config.fn-utils')
local M = {
    name = 'nvim-colorscheme',
    -- dev = true,
    lazy = false,
    priority = 1000,
    cond = not vim.g.vscode,
}

-- INFO: selection colorscheme
local theme = require('plugins.colorscheme.kanagawa-config')
M = utils.merge(M, theme.info)
M.config = theme.setup
M.colors = theme.colors()
M.lualine = theme.lualine()

return M
