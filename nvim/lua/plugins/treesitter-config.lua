local M = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-context', opts = { zindex = 5 } },
        'JoosepAlviste/nvim-ts-context-commentstring',
        'windwp/nvim-ts-autotag',
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    main = 'nvim-treesitter.configs'
}

M.opts = function()
    local keymaps = require('config.keymaps').treesitter

    for k, _ in pairs(keymaps.textobjects) do
        keymaps.textobjects[k].enable = true
    end

    return {
        ensure_installed = {
            'regex',
            'lua',
            'vim',
            'vimdoc',
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
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
        autotag = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = keymaps.incremental_selection,
        },
        textobjects = {
            move = keymaps.textobjects.move,
            swap = keymaps.textobjects.swap,
        },
    }
end

return M
