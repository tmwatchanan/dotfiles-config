-- ----------------------------------------------------------------------
-- INFO: lsp server manager config
--
local mason_module = {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonUpdate' },
}

mason_module.opts = {
    ui = {
        border = require('config').defaults.float_border
    }
}

-- ----------------------------------------------------------------------
-- INFO: LSP config
--
local lsp_setup_module = {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
        'mason.nvim',
        'cmp-nvim-lsp',
        'neovim/nvim-lspconfig',
        'williamboman/mason-lspconfig.nvim',
    },
}

lsp_setup_module.init = function()
    vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        virtual_text = false,
        virtual_lines = true,
    }
end

lsp_setup_module.config = function()
    -- ----------------------------------------------------------------------
    --  lsp configs
    --
    local lspconfig = require('lspconfig')
    local lsp_methods = vim.lsp.protocol.Methods

    local load_local_settings = function(path, server_name)
        vim.validate { path = { path, 's' } }

        local fname = string.format('%s/%s.json', path, server_name)
        local ok, result = pcall(vim.fn.readfile, fname)
        if not ok then return nil end

        result = table.concat(result)
        result = vim.json.decode(result)
        return result
    end

    -- INFO:  inject `esp-clang`, use specific fork clang from espressif
    --  also add `query-driver` for specific toolchains not from builtin binary
    lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
        on_new_config = lspconfig.util.add_hook_before(lspconfig.util.default_config.on_new_config,
            function(config, root_dir)
                local new_default_config = load_local_settings(root_dir, config.name)
                if new_default_config then
                    for k, v in pairs(new_default_config) do config[k] = v end
                end
            end)
    })

    -- INFO: config lsp log with formatting
    vim.lsp.set_log_level 'off' --    Levels by name: "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"
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
    local function lsp_inlayhint(client, bufnr)
        -- INFO: enable inlay hints when enter insert mode and disable when leave
        if client.supports_method(lsp_methods.textDocument_inlayHint) then
            local inlayhint_augroup = vim.api.nvim_create_augroup('inlayhint_augroup', { clear = false })

            vim.api.nvim_create_autocmd('InsertEnter', {
                buffer = bufnr,
                group = inlayhint_augroup,
                callback = function() vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end,
            })
            vim.api.nvim_create_autocmd('InsertLeave', {
                buffer = bufnr,
                group = inlayhint_augroup,
                callback = function() vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) end,
            })
        end
    end


    -- ----------------------------------------------------------------------
    --  lsp-zero configs
    --
    local lsp_zero = require('lsp-zero')

    local lsp_attach = function(client, bufnr)
        lsp_zero.highlight_symbol(client, bufnr)

        lsp_keymap(client, bufnr, require('config.keymaps').lsp)
        lsp_inlayhint(client, bufnr)
    end

    lsp_zero.extend_lspconfig {
        float_border = 'rounded',
        sign_text = require('config').defaults.icons.diagnostics,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        lsp_attach = lsp_attach,
    }

    -- INFO: config lsp servers in lsp-list
    local lsp_list = {}
    for name, config in pairs(require('plugins.lsp-settings.lsp-list')) do
        lsp_zero.configure(name, config)
        table.insert(lsp_list, name)
    end

    -- NOTE: manually injects unsupported lsp by mason.nvim, need to manually update lsp list to be automatically installed
    -- lsp.configure('ccls', {
    --     on_attach = lsp_attach,
    -- })

    -- INFO: automatically setup lsp from default config installed via mason.nvim
    require('mason-lspconfig').setup {
        ensure_installed = lsp_list,
        handlers = { lsp_zero.default_setup }
    }
end

local diagflow_module = {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
}

diagflow_module.opts = {
    scope = 'line',
    padding_top = 2,
    toggle_event = { 'InsertEnter', 'InsertLeave' },
    update_event = { 'DiagnosticChanged', 'BufEnter' },
    severity_colors = {
        error = 'DiagnosticError',
        warn = 'DiagnosticWarn',
        info = 'DiagnosticInfo',
        hint = 'DiagnosticHint',
    },
}

return {
    mason_module,
    lsp_setup_module,
    diagflow_module,
}
