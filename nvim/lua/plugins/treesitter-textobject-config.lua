local mini_ai_module = {
    'echasnovski/mini.ai',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            init = function()
                -- no need to load the plugin, since we only need its queries
                require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
            end,
        },
    },
    event = 'VeryLazy',
}

mini_ai_module.opts = function()
    local ai = require('mini.ai')
    local spec_treesitter = ai.gen_spec.treesitter

    return {
        n_lines = 100,
        search_method = 'cover_or_nearest',
        custom_textobjects = {
            -- `echasnovski/mini.nvim #366` mini.ai handles quotes worse than neovim
            ['"'] = false,
            ["'"] = false,

            o = spec_treesitter({ a = '@block.outer', i = '@block.inner' }),
            f = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
            x = spec_treesitter({ a = '@call.outer', i = '@call.inner' }),
            r = spec_treesitter({ a = '@return.outer', i = '@return.inner' }),
            c = spec_treesitter({ a = '@comment.inner', i = '@comment.outer' }),
            C = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
            ['='] = spec_treesitter({
                a = { '@assignment.lhs', '@keyword_argument_name', '@field_name' },
                i = { '@assignment.rhs', '@keyword_argument_value', '@field_value' },
            }),
            e = spec_treesitter({ a = '@assignment.outer', i = '@assignment.inner' }),
            d = spec_treesitter({ a = '@number.inner', i = '@number.inner' }),

            E = spec_treesitter({ a = '@local_variable_declaration', i = '@local_variable_declaration' }),
            v = spec_treesitter({ a = '@field_value', i = '@field_value' }),
            k = spec_treesitter({ a = '@field_name.outer', i = '@field_name.inner' }),
            F = spec_treesitter({ a = '@field_outer', i = '@field_inner' }),
            y = spec_treesitter({ a = '@loop.outer', i = '@loop.inner' }),
            Y = spec_treesitter({ a = '@for_in_clause_right', i = '@for_in_clause_left' }),
            u = spec_treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
            U = spec_treesitter({ a = '@if_clause', i = '@comparison_operator' }),
            t = spec_treesitter({
                a = { '@type', '@assignment_left', '@typed_parameter_identifier' },
                i = '@type',
            }),
        },
    }
end


local various_textobjs_module = {
    'chrisgrieser/nvim-various-textobjs',
    event = 'UIEnter',
    opts = {
        useDefaultKeymaps = true,
        disabledKeymaps = require('config.keymaps').treesitter.textobjects.various_textobjs.disabledKeymaps,
    },
}

local function delete_surrounding_indentation()
    -- select outer indentation
    require('various-textobjs').indentation('outer', 'outer')

    -- plugin only switches to visual mode when a textobj has been found
    local indentationFound = vim.fn.mode():find('V')
    if not indentationFound then return end

    -- dedent indentation
    vim.cmd.normal { '<', bang = true }

    -- delete surrounding lines
    local endBorderLn = vim.api.nvim_buf_get_mark(0, '>')[1]
    local startBorderLn = vim.api.nvim_buf_get_mark(0, '<')[1]
    vim.cmd(tostring(endBorderLn) .. ' delete') -- delete end first so line index is not shifted
    vim.cmd(tostring(startBorderLn) .. ' delete')
end


various_textobjs_module.keys = function()
    local keymaps = require('config.keymaps').treesitter.textobjects.various_textobjs
    return {
        { mode = 'n',          keymaps.delete_surrounding_indentation, function() delete_surrounding_indentation() end },
        { mode = { 'o', 'x' }, keymaps.value_outer,                    '<cmd>lua require("various-textobjs").value("outer")<CR>' },
        { mode = { 'o', 'x' }, keymaps.value_inner,                    '<cmd>lua require("various-textobjs").value("inner")<CR>' },
        { mode = { 'o', 'x' }, keymaps.key_outer,                      '<cmd>lua require("various-textobjs").key("outer")<CR>' },
        { mode = { 'o', 'x' }, keymaps.key_inner,                      '<cmd>lua require("various-textobjs").key("inner")<CR>' },
        { mode = { 'o', 'x' }, keymaps.pyTripleQuotes_outer,           '<cmd>lua require("various-textobjs").pyTripleQuotes("outer")<CR>' },
        { mode = { 'o', 'x' }, keymaps.pyTripleQuotes_inner,           '<cmd>lua require("various-textobjs").pyTripleQuotes("inner")<CR>' },
    }
end

return {
    mini_ai_module,
    various_textobjs_module,
}
