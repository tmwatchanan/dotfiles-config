local M = {
    'nyoom-engineering/oxocarbon.nvim',
    name = 'nvim-colorscheme',
    lazy = false,
    priority = 1000,
}

M.config = function()
    require('plugins.colorscheme.oxocarbon-config').setup()
end

M.lualine = function ()
   return require('plugins.colorscheme.oxocarbon-config').lualine() or 'auto'
end

return M
