local M = {
    'folke/flash.nvim',
    event = 'VeryLazy',
}

M.opts = {
    search = {
        multi_window = false,
        -- mode = 'fuzzy',
        -- incremental = true,
    },
    modes = {
        char = {
            multi_line = false,
            jump_labels = true,
        }
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
