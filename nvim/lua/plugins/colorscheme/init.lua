local utils = require('config.fn-utils')
local M = {
    name = 'nvim-colorscheme',
    lazy = false,
    priority = 1000,
}

-- INFO: oxocarbon colorscheme
local oxocarbon = require('plugins.colorscheme.oxocarbon-config')
M = utils.merge(M, oxocarbon.info)
M.config = oxocarbon.setup
M.lualine = oxocarbon.lualine

-- INFO: flow colorscheme
-- local flow = require('plugins.colorscheme.flow-config')
-- M = utils.merge(M, flow.info)
-- M.config = flow.setup
-- M.lualine = flow.lualine

return M
