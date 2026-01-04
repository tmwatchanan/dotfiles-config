local utils = require('config.fn-utils')
local M = {
    name = 'nvim-colorscheme',
    -- dir = '~/Developer/nvim-plugins/', -- NOTE: as for dev, path to local plugin
    lazy = false,
    priority = 1000,
}

-- INFO: selection colorscheme
local theme = require('plugins.colorscheme.oxocarbon-config')
M = utils.merge(M, theme.info)
M.config = theme.setup
M.colors = theme.colors()
M.lualine = theme.lualine()

return M
