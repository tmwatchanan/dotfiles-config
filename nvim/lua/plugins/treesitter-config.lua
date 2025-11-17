local M = {
    'MeanderingProgrammer/treesitter-modules.nvim',
    event = 'BufEnter',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            branch = 'main',
        },
        {
            'nvim-treesitter/nvim-treesitter-context',
            opts = { zindex = 5, max_lines = 3 },
        },
        {
            'folke/ts-comments.nvim',
            opts = true
        },
    },
}

M.opts = function()
    -- NOTE: extra parser register if filetype not matched
    -- vim.treesitter.language.register('ini', { 'dosini', 'confini' }) -- supported

    return {
        ensure_installed = {
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
    }
end

return M
