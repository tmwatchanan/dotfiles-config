local M = {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'hiphish/rainbow-delimiters.nvim' },
    cond = not vim.g.vscode,
}

M.opts = function()
    local highlight = {
        'RainbowDelimiterCyan',
        'RainbowDelimiterViolet',
        'RainbowDelimiterGreen',
        'RainbowDelimiterOrange',
        'RainbowDelimiterBlue',
        'RainbowDelimiterYellow',
        'RainbowDelimiterRed',
    }

    return {
        indent = {
            char = '▏',
            smart_indent_cap = true,
        },
        scope = {
            show_start = false,
            show_end = false,
            highlight = highlight,
            include = {
                node_type = {
                    python = {
                        'if_statement',
                        'for_statement',
                        'expression_statement',
                        'raise_statement',
                        'call',
                        'try_statement',
                        'dictionary',
                        'with_statement',
                    },
                    lua = {
                        'function_call',
                        'assignment_statement',
                        'table_constructor',
                    },
                },
            },
        },
        debounce = 300
    }
end

M.config = function(_, opts)
    require('ibl').setup(opts)

    local hooks = require('ibl.hooks')
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M
