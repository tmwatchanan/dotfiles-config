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
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                },
                maxPreload = 10000,
                preloadFileSize = 10000,
                checkThirdParty = false,
                ignoreDir = {
                    '**/node_modules/**',
                },
            },
        },
    },
}
