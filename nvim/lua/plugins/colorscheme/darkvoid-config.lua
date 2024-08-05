local M = {}

M.info  = { 'aliqyan-21/darkvoid.nvim' }

M.setup = function()
    require('darkvoid').setup {
        transparent = true,
        glow = true,
        show_end_of_buffer = true,
    }
end

M.lualine = function ()
    return 'auto'
end

return M
