-- ----------------------------------------------------------------------
-- INFO: lsp server manager config
--
local mason_module = {
    'williamboman/mason.nvim',
    branch = 'v2.x',
    cmd = { 'Mason', 'MasonUpdate' },
    cond = not vim.g.vscode,
}

mason_module.opts = {
    ui = {
        border = 'solid',
    },
    pip = {
        upgrade_pip = true,
    },
}

-- ----------------------------------------------------------------------
-- INFO: LSP config
--
local lsp_setup_module = {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'mason.nvim',
    },
    cond = not vim.g.vscode,
}

lsp_setup_module.init = function()
    vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        virtual_text = false,
        virtual_lines = false,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN] = '',
                [vim.diagnostic.severity.INFO] = '',
                [vim.diagnostic.severity.HINT] = '',
            },
            numhl = {
                [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
                [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
                [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
                [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
            },
        }
    }
end

lsp_setup_module.config = function()
    local lspconfig = require('lspconfig')
    local lsp_methods = vim.lsp.protocol.Methods

    local load_local_settings = function(path, server_name)
        vim.validate('path', path, 'string')

        local fname = string.format('%s/%s.json', path, server_name)
        local ok, result = pcall(vim.fn.readfile, fname)
        if not ok then return nil end

        result = table.concat(result)
        result = vim.json.decode(result)
        return result
    end

    -- NOTE:  inject `esp-clang`, use specific fork clang from espressif
    --  also add `query-driver` for specific toolchains not from builtin binary
    lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
        on_new_config = lspconfig.util.add_hook_before(lspconfig.util.default_config.on_new_config,
            function(config, root_dir)
                local new_default_config = load_local_settings(root_dir, config.name)
                if new_default_config then
                    for k, v in pairs(new_default_config) do config[k] = v end
                end

                if config.name == "julials" then
                    require('plugins.julia-config').install_language_server()
                end
            end),
    })

    -- INFO: config lsp log with formatting
    vim.lsp.set_log_level 'ERROR' --    Levels by name: 'TRACE', 'DEBUG', 'INFO', 'WARN', 'ERROR', 'OFF'
    -- require('vim.lsp.log').set_format_func(vim.inspect)

    -- INFO: check if eslint is attach then enable documentFormattingProvider
    local function check_eslint(client)
        if client.name == 'eslint' then
            client.server_capabilities.documentFormattingProvider = true
            return true
        end
        return false
    end

    -- INFO: config lsp keymaps
    local function lsp_keymap(client, bufnr, mapping)
        local opts = { buffer = bufnr, silent = true, noremap = true }

        -- INFO: always call formatting with restrict to eslint if found
        if check_eslint(client) then
            mapping.format.cmd = function() vim.lsp.buf.format({ async = true, name = client.name }) end
        end

        for _, keymap in pairs(mapping) do
            vim.keymap.set('n', keymap.key, keymap.cmd, opts)
        end
    end

    -- INFO: config lsp inlay hints
    vim.g.show_inlay_hint = true
    local function lsp_inlayhint(client, bufnr)
        -- INFO: enable inlay hints when enter insert mode and disable when leave
        if client:supports_method(lsp_methods.textDocument_inlayHint) then
            local inlayhint_augroup = vim.api.nvim_create_augroup('inlayhint_augroup', { clear = false })

            vim.api.nvim_create_autocmd('InsertEnter', {
                buffer = bufnr,
                group = inlayhint_augroup,
                callback = function() vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end,
            })
            vim.api.nvim_create_autocmd('InsertLeave', {
                buffer = bufnr,
                group = inlayhint_augroup,
                callback = function()
                    if not vim.g.show_inlay_hint then
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                    end
                end,
            })
        end
    end

    -- INFO: lsp highlight symbols
    local function lsp_highlight_symbol(client, bufnr)
        if not (client and client:supports_method('textDocument/documentHighlight')) then
            return
        end

        bufnr = bufnr and bufnr ~= 0 and bufnr or vim.api.nvim_get_current_buf()

        local augroup = vim.api.nvim_create_augroup('lsp_highlight_symbol', { clear = false })
        local autocmd_opts = { group = augroup, buffer = bufnr }

        vim.api.nvim_clear_autocmds(autocmd_opts)

        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' },
            vim.tbl_extend('force', autocmd_opts, {
                callback = vim.lsp.buf.document_highlight,
            })
        )

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' },
            vim.tbl_extend('force', autocmd_opts, {
                callback = vim.lsp.buf.clear_references,
            })
        )
    end

    -- NOTE: lsp attach callback
    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local bufnr = event.buf
            local id = vim.tbl_get(event, 'data', 'client_id')
            local client = id and vim.lsp.get_client_by_id(id) or {}

            lsp_keymap(client, bufnr, require('config.keymaps').lsp)
            vim.lsp.inlay_hint.enable(vim.g.show_inlay_hint, { bufnr = bufnr })
            lsp_inlayhint(client, bufnr)
            lsp_highlight_symbol(client, bufnr);
        end
    })


    -- NOTE: config lsp servers in lsp-list
    local lsp_names = {}
    local lsp_configs = require('plugins.lsp-settings.lsp-list')
    for name, _ in pairs(lsp_configs) do
        table.insert(lsp_names, name)
    end

    -- NOTE: automatically setup lsp from default config installed via mason.nvim
    local lsp_capabilities = require('blink.cmp').get_lsp_capabilities()
    lsp_capabilities.textDocument.foldingRange = { -- INFO: nvim-ufo
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
    require('mason-lspconfig').setup {
        ensure_installed = lsp_names,
        handlers = {
            function(server_name)
                lsp_configs[server_name] = lsp_configs[server_name] or {}
                lsp_configs[server_name].capabilities = lsp_capabilities
                lspconfig[server_name].setup(lsp_configs[server_name])
            end,
        },
    }
end

local diagflow_module = {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    cond = not vim.g.vscode,
}

diagflow_module.opts = {
    scope = 'cursor',
    padding_top = 2,
    toggle_event = { 'InsertEnter', 'InsertLeave' },
    severity_colors = {
        error = 'DiagnosticError',
        warn = 'DiagnosticWarn',
        info = 'DiagnosticInfo',
        hint = 'DiagnosticHint',
    },
}

-- ----------------------------------------------------------------------
-- INFO: formatter
--
local formatter_module = {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'plenary.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        local formatters = require('plugins.lsp-settings.formatters')
        require('mason-tool-installer').setup(formatters.mason_tool_installer)
        require('mason-tool-installer').check_install(false)
        require('null-ls').setup(formatters.none_ls)
    end,
    cond = not vim.g.vscode,
}

return {
    mason_module,
    lsp_setup_module,
    diagflow_module,
    formatter_module,
}
