local M = {
    'folke/flash.nvim',
    event = 'VeryLazy',
    dev = true,
}

M.opts = {
    search = {
        multi_window = false,
        -- mode = 'fuzzy',
        -- incremental = true,
    },
    modes = {
        char = {
            jump_labels = true,
            multi_line = false,
            jump = {
                autojump = true,
            },
        },
    },
}

M.keys = function()
    local flash_keymap = require('config.keymaps').flash

    return {
        {
            flash_keymap.flash,
            mode = { 'n', 'o' },
            function() require('flash').jump({ search = { multi_window = true } }) end,
            desc = 'Flash'
        },
        {
            flash_keymap.flash_treesitter,
            mode = { 'n', 'o', 'x' },
            function() require('flash').treesitter_search({ search = { multi_window = true } }) end,
            desc = 'Flash Treesitter'
        },
    }
end

return M
