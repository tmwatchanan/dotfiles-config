local mini_ai_module = {
    'echasnovski/mini.ai',
    main = 'mini.ai',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            -- init = function()
            --     -- no need to load the plugin, since we only need its queries
            --     require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
            -- end,
        },
    }
}

mini_ai_module.opts = function()
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
            m = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
            i = ai.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }, {}),
            c = ai.gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }, {}),
            C = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
            ['='] = ai.gen_spec.treesitter({ a = '@assignment.lhs', i = '@assignment.rhs' }, {}),
        },
    }
end

mini_ai_module.keys = {
    { 'a', mode = { 'x', 'o' } },
    { 'i', mode = { 'x', 'o' } },
    { 'g]' },
    { 'g[' },
}

local various_textobjs_module = {
    'chrisgrieser/nvim-various-textobjs',
    lazy = false,
    opts = {
        useDefaultKeymaps = true,
        disabledKeymaps = {
            'r', -- restOfParagraph
        },
    },
}

local function delete_surrounding_indentation()
    -- select inner indentation
    require('various-textobjs').indentation(true, true)

    -- plugin only switches to visual mode when a textobj has been found
    local notOnIndentedLine = vim.fn.mode():find('V') == nil
    if notOnIndentedLine then return end

    -- dedent indentation
    vim.cmd.normal { '<', bang = true }

    -- delete surrounding lines
    local endBorderLn = vim.api.nvim_buf_get_mark(0, '>')[1] + 1
    local startBorderLn = vim.api.nvim_buf_get_mark(0, '<')[1] - 1
    vim.cmd(tostring(endBorderLn) .. ' delete') -- delete end first so line index is not shifted
    vim.cmd(tostring(startBorderLn) .. ' delete')
end


various_textobjs_module.keys = function()
    return {
        { 'dsi', function() delete_surrounding_indentation() end, mode = 'n' },
    }
end

return {
    mini_ai_module,
    various_textobjs_module,
}
