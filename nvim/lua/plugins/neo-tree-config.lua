local M = {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'plenary.nvim',
        'nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        -- '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    cmd = 'Neotree',
}

M.opts = {
    window = {
        position = 'right',
    },
    filesystem = {
        follow_current_file = {
            enabled = true,
        },
    }
}

M.keys = function()
    local keymap = require('config.keymaps').neotree

    return {
        { keymap.toggle, '<Cmd>Neotree toggle<CR>' },
    }
end

return M
