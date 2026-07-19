-- INFO: personal opt-out list for LSP servers.
-- Servers named here keep their upstream `after/lsp/<name>.lua` file intact but
-- are skipped from mason install (`ensure_installed`) and auto-enable.
-- Add/remove names freely; this file is not owned by upstream, so it won't
-- conflict on merge.
return {
    'clangd',
    'eslint',
    'vtsls',
    'vue_ls',
}
