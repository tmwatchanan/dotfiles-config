local M = {
    'rebelot/kanagawa.nvim',
    name = 'nvim-colorscheme',
    lazy = false,
    priority = 1000,
}

M.config = function()
    require('plugins.colorscheme.kanagawa-config').setup()
end

M.lualine = function ()
   return require('plugins.colorscheme.kanagawa-config').lualine() or 'auto'
end

return M
