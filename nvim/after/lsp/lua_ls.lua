return {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            hint = {
                enable = true,
            },
            completion = {
                callSnippet = 'Replace',
            },
            diagnostics = {
                enable = true,
                globals = { 'vim', 'use' },
            },
            hint = {
                enable = true,
                arrayIndex = 'Disable',
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                },
                ignoreDir = {
                    '**/node_modules/**',
                },
            },
        },
    },
}
