local M = {
    'echasnovski/mini.ai',
    main = 'mini.ai',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            init = function()
                -- no need to load the plugin, since we only need its queries
                require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
            end,
        },
    }
}

M.opts = function()
    local ai = require('mini.ai')

    return {
        n_lines = 500,
        search_method = 'cover_or_nearest',
        custom_textobjects = {
            o = ai.gen_spec.treesitter({
                a = { '@block.outer', '@conditional.outer', '@loop.outer' },
                i = { '@block.inner', '@conditional.inner', '@loop.inner' },
            }, {}),
            r = ai.gen_spec.treesitter({ a = '@return.outer', i = '@return.inner' }, {}),
            f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
            c = ai.gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }, {}),
            C = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
            ['='] = ai.gen_spec.treesitter({ a = "@assignment.lhs", i = "@assignment.rhs" }, {}),
        },
    }
end

M.keys = {
    { 'a', mode = { 'x', 'o' } },
    { 'i', mode = { 'x', 'o' } },
    { 'g]' },
    { 'g[' },
}

return M
