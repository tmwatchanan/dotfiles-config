local M = {
    'folke/flash.nvim',
}

M.opts = {
    search = {
        multi_window = false,
        -- mode = 'fuzzy',
        -- incremental = true,
    },
    modes = {
        search = {
            enabled = true,
        },
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
        { 'f', mode = 'n' },
        { 't', mode = 'n' },
        { 'F', mode = 'n' },
        { 'T', mode = 'n' },
        {
            flash_keymap.flash,
            mode = { 'n', 'o' },
            function()
                require('flash').jump({
                    search = { multi_window = true },
                })
            end,
            desc = 'Flash'
        },
        {
            flash_keymap.flash_treesitter,
            mode = { 'n', 'o', 'x' },
            function()
                require('flash').treesitter_search({
                    search = { multi_window = true },
                })
            end,
            desc = 'Flash Treesitter'
        },
        {
            flash_keymap.flash_current_word,
            mode = { 'n', 'o', 'x' },
            function()
                require('flash').jump({
                    pattern = vim.fn.expand('<cword>'),
                    search = { multi_window = true },
                })
            end,
            desc = 'Flash with the word under the cursor'
        },
        {
            flash_keymap.flash_continue,
            mode = { 'n', 'o', 'x' },
            function()
                require('flash').jump({
                    continue = true,
                })
            end,
            desc = 'Flash continue last search'
        },
    }
end

return M
