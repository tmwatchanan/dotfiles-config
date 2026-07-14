vim.filetype.add({
    -- env files use the builtin `env` filetype; treesitter maps it to the
    -- `properties` parser (see treesitter-config), since bash mis-parses
    -- values like `<placeholder>` as redirects
    extension = {
        env = 'env',
    },
    filename = {
        ['.env'] = 'env',
    },
    pattern = {
        ['%.env%.[%w_.-]+'] = { 'env', { priority = 10 } },
        ['%.gitconfig%.[%w_.-]+'] = 'gitconfig',
    },
})
