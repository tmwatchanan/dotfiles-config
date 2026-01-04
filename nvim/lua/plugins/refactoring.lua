local M = {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
}

M.config = function()
    require('refactoring').setup({
        prompt_func_return_type = {
            python = false,
        },
        prompt_func_param_type = {
            python = false,
        },
    })
end

M.keys = function()
    local refactoring_keymap = require('config.keymaps').refactoring

    return {
        {
            refactoring_keymap.extract_function,
            function() require('refactoring').refactor('Extract Function') end,
            mode = 'v',
            noremap = true, silent = true, expr = false,
        },
        {
            refactoring_keymap.extract_function_to_file,
            function() require('refactoring').refactor('Extract Function To File') end,
            mode = 'v',
            noremap = true, silent = true, expr = false,
        },
        {
            refactoring_keymap.extract_variable,
            function() require('refactoring').refactor('Extract Variable') end,
            mode = 'v',
            noremap = true, silent = true, expr = false,
        },
        {
            refactoring_keymap.inline_variable,
            function() require('refactoring').refactor('Inline Variable') end,
            mode = { 'v', 'n' },
            noremap = true, silent = true, expr = false,
        },
        {
            refactoring_keymap.extract_block,
            function() require('refactoring').refactor('Extract Block') end,
            mode = 'n',
            noremap = true, silent = true, expr = false,
        },
        {
            refactoring_keymap.extract_block_to_file,
            function() require('refactoring').refactor('Extract Block To File') end,
            mode = 'n',
            noremap = true, silent = true, expr = false,
        },
        {
            refactoring_keymap.print_var,
            function() require('refactoring').debug.print_var({ normal = true }) end,
            mode = 'n',
            noremap = true,
        },
        {
            refactoring_keymap.print_var,
            function() require('refactoring').debug.print_var({}) end,
            mode = 'v',
            noremap = true,
        },
        {
            refactoring_keymap.debug_cleanup,
            function() require('refactoring').debug.cleanup({}) end,
            mode = 'n',
            noremap = true,
        },
    }
end

return M
