local M = {
    'RRethy/vim-illuminate',
    event = 'BufReadPost'
}

M.config = function()
    local illuminate = require('illuminate')
    illuminate.configure({
        delay = 200,
        filetypes_denylist = {
            'dirvish',
            'fugitive',
            'man',
            'checkhealth',
            'help',
            'terminal',
            'packer',
            'lspinfo',
            'lsp-installer',
            'TelescopePrompt',
            'TelescopeResults',
        },
    })
end

return M
