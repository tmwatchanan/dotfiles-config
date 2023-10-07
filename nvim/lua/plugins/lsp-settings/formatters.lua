return {
    mason_tool_installer = {
        ensure_installed = {
            'isort',
            'black',
            'prettierd',
        },
    },
    none_ls = {
        sources = {
            require('null-ls').builtins.formatting.isort,
            require('null-ls').builtins.formatting.black,
            require('null-ls').builtins.formatting.prettierd,
        },
    },
}
