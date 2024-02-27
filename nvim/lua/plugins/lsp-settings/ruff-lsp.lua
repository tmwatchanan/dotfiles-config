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
    cmd = { 'ruff-lsp' },
    filetypes = { 'python' },
    root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor,
    single_file_support = true,
    init_options = {
        settings = {
            args = {},
            lint = { args = { "--line-length=88" } },
            format = { args = { "--line-length=88" } },
        },
    },
}
