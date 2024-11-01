local M = {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-web-devicons' },
    lazy = false,
    opts = {
        columns = {
            'icon',
            'size',
        },
        view_options = {
            show_hidden = true,
        },
        delete_to_trash = true,
        keymaps = {
            -- close
            ['qq'] =  'actions.close',
            ['<leader><Tab>'] = 'actions.close',

            -- open tab
            ['<C-t>'] = false,

            -- open split
            ['<C-h>'] = false,
            ['<C-s>'] = 'actions.select_split',
            ['<C-v>'] = 'actions.select_vsplit',

            -- refresh
            ['<C-l>'] = false,
            ['<C-r>'] = 'actions.refresh',

            -- parent
            ['-'] = false,
            ['<BS>'] = 'actions.parent',

            -- trash
            ['gt'] = 'actions.toggle_trash',
        },
    },
    cond = not vim.g.vscode,
}

M.keys = function()
    local keymap = require('config.keymaps').oil
    return {
        { keymap.open, '<Cmd>Oil<CR>', desc = '[oil.nvim] open parent directory' },
    }
end

return M
