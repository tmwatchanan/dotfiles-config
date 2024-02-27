return {
    mason_tool_installer = {
        ensure_installed = {
            'prettierd',
        },
    },
    none_ls = {
        sources = {
            require('null-ls').builtins.formatting.prettierd,
        },
    },
}
