local M = {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        -- '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    cmd = 'Neotree',
    cond = not vim.g.vscode,
}

M.opts = {
    window = {
        position = 'right',
        mappings = {
            -- Copy the absolute file path to the system clipboard
            ['Y'] = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.fn.setreg('+', path)
                vim.notify('Copied path: ' .. path)
            end,
        },
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
