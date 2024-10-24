return {
    mason_tool_installer = {
        ensure_installed = {
            'prettierd',
        },
    },
    none_ls = {
        sources = {
            require('null-ls').builtins.formatting.prettierd,

            require('null-ls').builtins.formatting.shfmt,
            require('null-ls').builtins.diagnostics.fish,
            require('null-ls').builtins.formatting.fish_indent,
            require('null-ls').builtins.formatting.buf,
        },
    },
}
