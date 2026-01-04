local M = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    event = 'BufEnter',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-context', opts = { zindex = 5, max_lines = 3 } },
        { 'folke/ts-comments.nvim',                  opts = {} },
    },
}

M.config = function()
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
end

return M
