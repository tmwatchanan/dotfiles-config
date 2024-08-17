local utils = require('config.fn-utils')
local M = {
    name = 'nvim-colorscheme',
    lazy = false,
    priority = 1000,
}

-- INFO: selection colorscheme
local theme = require('plugins.colorscheme.kanagawa-config')
M = utils.merge(M, theme.info)
M.config = theme.setup
M.lualine = theme.lualine

return M