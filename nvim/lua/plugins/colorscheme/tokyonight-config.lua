local M = {}

M.info = { 'folke/tokyonight.nvim' }

M.setup = function()
    require('tokyonight').setup({
        on_colors = function(colors)
            local pink = '#fca7ea'
            colors.purple = pink
            MiniIconsPurple = {
                fg = pink
            }
        end
    })
    vim.cmd [[colorscheme tokyonight-night]]
end

M.lualine = function()
    return 'tokyonight'
end

M.colors = function()
    local tokyonight_status, _ = pcall(require, 'tokyonight')
    if not tokyonight_status then return end

    local colors = require('tokyonight.colors').setup()
    return colors
end

return M
