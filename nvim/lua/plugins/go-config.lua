local M = {
    'ray-x/go.nvim',
    dependencies = {
        'ray-x/guihua.lua',
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
    },
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}

M.opts = {
    lsp_cfg = true,
    test_runner = 'go',
    trouble = true,
}

return M
