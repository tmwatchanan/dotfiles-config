local M = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    event = 'BufEnter',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-context', opts = { zindex = 5, max_lines = 3 } },
        { 'folke/ts-comments.nvim',                  opts = true },
    },
}


M.config = function()
    local utils = require('config.fn-utils')

    local ensure_installed = {
        'regex',
        'lua',
        'vim',
        'vimdoc',
        'markdown',
        'markdown_inline',
        'bash',
        'nu',
        'yaml',
        'tsx',
        'javascript',
        'css',
        'scss',
        'latex',
    }
    require('nvim-treesitter').install(ensure_installed)

    -- NOTE: extra parser register if filetype not matched
    -- vim.treesitter.language.register('ini', { 'dosini', 'confini' }) -- supported
    --

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter.setup', {}),
        callback = function(args)
            local buf = args.buf
            local filetype = args.match

            -- you need some mechanism to avoid running on buffers that do not
            -- correspond to a language (like oil.nvim buffers), this implementation
            -- checks if a parser exists for the current language
            local language = vim.treesitter.language.get_lang(filetype) or filetype
            if not vim.treesitter.language.add(language) then
                return
            end

            -- replicate `fold = { enable = true }`
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

            -- replicate `highlight = { enable = true }`
            vim.treesitter.start(buf, language)

            -- replicate `indent = { enable = true }`
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })

    return {
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
            keymaps = require('config.keymaps').treesitter.incremental_selection,
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

-- M.config = function(_, opts)
--     require('nvim-treesitter.configs').setup(opts)
--
--     -- INFO: Repeat movement with ]; and [;
--     local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
--     local repeat_keymaps = require('config.keymaps').treesitter.textobjects.repeat_move
--     vim.keymap.set({ 'n', 'x', 'o' }, repeat_keymaps.repeat_last_move_next, ts_repeat_move.repeat_last_move_next)
--     vim.keymap.set({ 'n', 'x', 'o' }, repeat_keymaps.repeat_last_move_previous, ts_repeat_move.repeat_last_move_previous)
-- end

return M
