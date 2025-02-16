local M = {}

M.info = { 'hylophile/flatwhite.nvim' }

M.setup = function()
    local flatwhite_status, _ = pcall(require, 'flatwhite')
    if not flatwhite_status then return end

    vim.opt.background = 'light'
    vim.cmd.colorscheme = 'flatwhite'
end

M.colors = function ()
    return {}
end

M.lualine = function()
    local flatwhite_status, _ = pcall(require, 'flatwhite')
    if not flatwhite_status then return end

    return 'flatwhite'
end

return M
