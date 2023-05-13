return {
    on_attach = function(client, _)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end,
    settings = {
        ruff_lsp = {
            args = {
                '--line-length', '88',
            },
        },
    },
}
