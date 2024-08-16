local util = require('lspconfig.util')

local root_files = {
    'pyproject.toml',
    'ruff.toml',
}

return {
    on_attach = function(client, _)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end,
    root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor,
    init_options = {
        settings = {
            lineLength = 88,
        },
    },
}
