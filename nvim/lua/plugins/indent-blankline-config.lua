local M = {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'blink.pairs' },
    event = 'VeryLazy',
}

M.opts = {
    indent = {
        char = '•',
        smart_indent_cap = true,
    },
    scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        highlight = {
            'BlinkPairsRed',
            'BlinkPairsYellow',
            'BlinkPairsBlue',
            'BlinkPairsOrange',
            'BlinkPairsGreen',
            'BlinkPairsViolet',
            'BlinkPairsCyan',
        },
    },
    debounce = 300
}

M.config = function(_, opts)
    require('ibl').setup(opts)

    local hooks = require('ibl.hooks')
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M
