local M = {
    'chrisgrieser/nvim-spider',
    lazy = true,
    dependencies = {
        "theHamsta/nvim_rocks",
        build = 'pip install --user hererocks && python -m hererocks . -j2.1.0-beta3 -r3.0.0 && sed -i "" "s/activate/activate.fish/g" nvim_rocks.lua && cp nvim_rocks.lua lua',
        config = function() require("nvim_rocks").ensure_installed("luautf8") end,
    },
}

M.keys = function()
    local spider_keymap = require('config.keymaps').spider

    return {
        { spider_keymap.old_w, 'w',                                          mode = { 'n', 'o', 'x' } },
        { spider_keymap.old_e, 'e',                                          mode = { 'n', 'o', 'x' } },
        { spider_keymap.old_b, 'b',                                          mode = { 'n', 'o', 'x' } },
        { spider_keymap.new_w, function() require('spider').motion('w') end, mode = { 'n', 'o', 'x' } },
        { spider_keymap.new_e, function() require('spider').motion('e') end, mode = { 'n', 'o', 'x' } },
        { spider_keymap.new_b, function() require('spider').motion('b') end, mode = { 'n', 'o', 'x' } },
    }
end

return M
