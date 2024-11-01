local M = {
    'ray-x/go.nvim',
    dependencies = {
        'ray-x/guihua.lua',
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    cond = not vim.g.vscode,
}

M.opts = {
    diagnostic = false, -- disable `vim.diagnostic` as it's already done in `lsp-config.lua`
    lsp_cfg = true,
    test_runner = 'go',
    trouble = true,
    lsp_inlay_hints = {
        enable = false,
    },
}

return M
