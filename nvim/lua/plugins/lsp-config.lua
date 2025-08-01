-- ----------------------------------------------------------------------
-- INFO: lsp server manager config
--
local mason_module = {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
        { 'mason-org/mason.nvim', opts = { ui = { border = 'solid' }, pip = { upgrade_pip = true } } },
        { 'nvim-lspconfig' }
    },
    event = 'BufEnter',
    cond = not vim.g.vscode,
}

mason_module.config = function()
    local load_local_settings = function(path, server_name)
        vim.validate('path', path, 'string')

        local fname = string.format('%s/%s.json', path, server_name)
        local ok, result = pcall(vim.fn.readfile, fname)
        if not ok or type(result) ~= 'table' or #result == 0 then return nil end

        local content = table.concat(result)
        if content == '' then return nil end

        local json_ok, decoded = pcall(vim.json.decode, content)
        if not json_ok then
            vim.notify('Failed to parse JSON from ' .. fname .. ': ' .. decoded, vim.log.levels.ERROR)
            return nil
        end

        return decoded
    end

    -- INFO: config lsp log with formatting
    vim.lsp.set_log_level 'off' --    Levels by name: "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"
    -- require('vim.lsp.log').set_format_func(vim.inspect)

    -- INFO: load LSP configurations from individual files in ~/.config/nvim/lsp directory
    local lsp_names = {}
    local lsp_dir = vim.fn.stdpath('config') .. '/after/lsp'

    vim.lsp.config('*', {
        capabilities = vim.lsp.protocol.make_client_capabilities()
    })

    for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
        local lsp_name = file:gsub('%.lua$', '')
        table.insert(lsp_names, lsp_name)

        -- NOTE: check local config if available and injected before lsp enabled
        local user_local_config = load_local_settings(vim.uv.cwd(), lsp_name)
        if user_local_config then
            vim.lsp.config(lsp_name, user_local_config)
        end
    end

    -- NOTE: automatically setup lsp from default config installed via mason.nvim
    require('mason-lspconfig').setup {
        ensure_installed = lsp_names,
        automatic_enable = true,
    }
end

-- ----------------------------------------------------------------------
-- INFO: LSP config
--
local lspconfig_module = {
    'neovim/nvim-lspconfig'
}

lspconfig_module.config = function()
    local lsp_methods = vim.lsp.protocol.Methods

    -- INFO: config lsp keymaps
    local function lsp_keymap(bufnr, mapping)
        local opts = { buffer = bufnr, silent = true, noremap = true }

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
        if not (client and client:supports_method(lsp_methods.textDocument_documentHighlight)) then
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
        desc = 'LSP features',
        callback = function(event)
            local bufnr = event.buf
            local id = vim.tbl_get(event, 'data', 'client_id')
            local client = id and vim.lsp.get_client_by_id(id) or {}

            lsp_keymap(bufnr, require('config.keymaps').lsp)
            vim.lsp.inlay_hint.enable(vim.g.show_inlay_hint, { bufnr = bufnr })
            lsp_inlayhint(client, bufnr)
            lsp_highlight_symbol(client, bufnr)
        end
    })
end

-- ref: https://www.reddit.com/r/neovim/comments/1jm5atz/comment/mk9w6v0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
---@param jumpCount number
lspconfig_module.jumpWithVirtLineDiags = function(jumpCount)
    pcall(vim.api.nvim_del_augroup_by_name, 'jumpWithVirtLineDiags') -- prevent autocmd for repeated jumps

    vim.diagnostic.jump { count = jumpCount }

    local initialVirtTextConf = vim.diagnostic.config().virtual_text
    vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = { current_line = true },
    }

    vim.defer_fn(function() -- deferred to not trigger by jump itself
        vim.api.nvim_create_autocmd('CursorMoved', {
            desc = 'User(once): Reset diagnostics virtual lines',
            once = true,
            group = vim.api.nvim_create_augroup('jumpWithVirtLineDiags', {}),
            callback = function()
                vim.diagnostic.config { virtual_lines = false, virtual_text = initialVirtTextConf }
            end,
        })
    end, 1)
end


-- ----------------------------------------------------------------------
-- INFO: Diagnostics config
--
local diagnostic_module = {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    cond = not vim.g.vscode,
}

diagnostic_module.init = function()
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

diagnostic_module.opts = {
    scope = 'line',
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
        {
            'jay-babu/mason-null-ls.nvim',
            dependencies = {
                'williamboman/mason.nvim',
                'WhoIsSethDaniel/mason-tool-installer.nvim',
            },
        },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('mason-null-ls').setup({
            ensure_installed = {
                'prettierd',
            },
        })
        local none_ls_config = {
            sources = {
                require('null-ls').builtins.formatting.prettierd,

                require('null-ls').builtins.formatting.shfmt,
                require('null-ls').builtins.diagnostics.fish,
                require('null-ls').builtins.formatting.fish_indent,
                require('null-ls').builtins.formatting.buf,
                require('null-ls').builtins.formatting.sqlfluff,
            },
        }
        require('null-ls').setup(none_ls_config)
    end,
    cond = not vim.g.vscode,
}

return {
    mason_module,
    lspconfig_module,
    diagnostic_module,
    formatter_module,
}
