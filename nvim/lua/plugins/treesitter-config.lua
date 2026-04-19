local M = {
    'neovim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = 'BufEnter',
    dependencies = {
        { 'neovim-treesitter/treesitter-parser-registry' },
        { 'nvim-treesitter/nvim-treesitter-context',     opts = { zindex = 5, max_lines = 3 } },
        { 'folke/ts-comments.nvim',                      opts = {} },
    },
}


M.config = function()
    local keymaps = require('config.keymaps').treesitter
    local utils = require('config.fn-utils')

    local ensure_install = {
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
    require('nvim-treesitter').install(ensure_install)

    -- NOTE: extra parser register if filetype not matched
    -- vim.treesitter.language.register('ini', { 'dosini', 'confini' }) -- supported
    vim.treesitter.language.register('jsonc', 'json')

    local installing = {}
    local lang_cache = {} -- filetype -> language | false
    local available_set -- lazy-built set of registry parsers

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter.setup', {}),
        callback = function(args)
            local buf = args.buf
            local ft = args.match

            -- resolve and cache filetype -> language mapping
            local language = lang_cache[ft]
            if language == nil then
                language = vim.treesitter.language.get_lang(ft) or ft
                lang_cache[ft] = (language ~= '') and language or false
            end
            if not language then
                return
            end

            if not vim.treesitter.language.add(language) then
                if installing[language] then
                    return
                end
                -- lazy-build available parser set once
                if not available_set then
                    available_set = {}
                    for _, l in ipairs(require('nvim-treesitter').get_available()) do
                        available_set[l] = true
                    end
                end
                if not available_set[language] then
                    lang_cache[ft] = false -- skip this filetype from now on
                    return
                end
                installing[language] = true
                require('nvim-treesitter').install(language)
                local timer = vim.uv.new_timer()
                timer:start(500, 500, vim.schedule_wrap(function()
                    if vim.treesitter.language.add(language) then
                        timer:stop()
                        timer:close()
                        installing[language] = nil
                        if vim.api.nvim_buf_is_valid(buf) then
                            vim.bo[buf].filetype = vim.bo[buf].filetype
                        end
                    end
                end))
                return
            end

            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.treesitter.start(buf, language)
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })

    return {
        ensure_installed = ensure_installed,
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
