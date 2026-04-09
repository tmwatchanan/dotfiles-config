local M = {}

M.info = {
    'momepp/oxocarbon.nvim',
    colorscheme = 'oxocarbon',
}

M.setup = function()
    vim.opt.background = 'dark'
    vim.cmd.colorscheme 'oxocarbon'

    vim.api.nvim_set_hl(0, 'SidekickChat', { bg = '#181818' })
end

M.lualine = function()
    return 'oxocarbon'
end

M.colors = function()
    local oxocarbon_status, oxocarbon = pcall(require, 'oxocarbon')
    if not oxocarbon_status then return {} end

    return oxocarbon.oxocarbon
end

return M
