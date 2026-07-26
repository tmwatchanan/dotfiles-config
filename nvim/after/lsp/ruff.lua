return {
    on_attach = function(client, _)
        -- Disable hover in favor of pyrefly
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            lineLength = 88,
        },
    },
}
