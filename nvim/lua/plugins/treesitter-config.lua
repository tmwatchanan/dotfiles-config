local M = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-context',
            opts = { zindex = 5, max_lines = 3 },
        },
        {
            'folke/ts-comments.nvim',
            opts = true
        },
        'nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    main = 'nvim-treesitter.configs'
}

M.opts = function()
    local keymaps = require('config.keymaps').treesitter
    local utils = require('config.fn-utils')

    return {
        ensure_installed = {
            'regex',
            'lua',
            'vim',
            'vimdoc',
            'html',
            'markdown',
            'markdown_inline',
            'bash',
            'fish',
            'yaml',
            'tsx',
            'javascript',
            'css',
            'scss',
            'python',
        },
        ignore_install = {
            'norg',
            'vala'
        },
        auto_install = true,
        sync_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
            disable = { 'cpp' }
        },
        incremental_selection = {
            enable = true,
            keymaps = keymaps.incremental_selection,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
            },
            move = utils.merge(
                {
                    enable = true,
                },
                keymaps.textobjects.move
            ),
            swap = utils.merge(
                {
                    enable = true,
                },
                keymaps.textobjects.swap
            ),
            lsp_interop = {
                enable = true,
                border = 'none',
                floating_preview_opts = {},
                peek_definition_code = keymaps.textobjects.peek_definition_code,
            },
        },
        matchup = {
            enable = true,
        },
    }
end

M.config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    -- INFO: Repeat movement with ]; and [;
    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
    local repeat_keymaps = require('config.keymaps').treesitter.textobjects.repeat_move
    vim.keymap.set({ 'n', 'x', 'o' }, repeat_keymaps.repeat_last_move_next, ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, repeat_keymaps.repeat_last_move_previous, ts_repeat_move.repeat_last_move_previous)
end

return M
