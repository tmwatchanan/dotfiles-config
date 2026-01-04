local M = {
    'backdround/neowords.nvim',
    lazy = false,
}

M.keys = function()
    local neowords_keymap = require('config.keymaps').neowords
    local neowords = require('neowords')
    local p = neowords.pattern_presets

    local hops = neowords.get_word_hops(
        p.snake_case,
        p.camel_case,
        p.upper_case,
        p.number,
        p.hex_color,
        '([\\u0E00-\\u0E7F]+)' -- Thai
    )

    return {
        { neowords_keymap.old_w, 'w',                 mode = { 'n', 'o', 'x' } },
        { neowords_keymap.old_e, 'e',                 mode = { 'n', 'o', 'x' } },
        { neowords_keymap.old_b, 'b',                 mode = { 'n', 'o', 'x' } },
        { neowords_keymap.new_w, hops.forward_start,  mode = { 'n', 'o', 'x' } },
        { neowords_keymap.new_e, hops.forward_end,    mode = { 'n', 'o', 'x' } },
        { neowords_keymap.new_b, hops.backward_start, mode = { 'n', 'o', 'x' } },
    }
end

return M

