return {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            completion = {
                callSnippet = 'Replace',
            },
            diagnostics = {
                enable = true,
                globals = { 'vim', 'use' },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                    -- '${3rd}/busted/library',
                },
                maxPreload = 10000,
                preloadFileSize = 10000,
                checkThirdParty = false,
            },
        },
    },
}
