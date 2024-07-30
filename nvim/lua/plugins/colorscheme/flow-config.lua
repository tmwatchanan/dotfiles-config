local M = {}

M.info  = { '0xstepit/flow.nvim' }

M.setup = function()
    require('flow').setup {
        transparent = true,
        fluo_color = 'pink',
        mode = 'normal',
        aggressive_spell = false,
    }
    vim.cmd.colorscheme 'flow'
end

return M
