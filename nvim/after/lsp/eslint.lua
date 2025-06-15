return {
    on_attach = function (client)
        client.server_capabilities.documentFormattingProvider = true
    end
}
