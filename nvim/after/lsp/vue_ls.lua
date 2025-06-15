return {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    init_options = {
        vue = {
            hybridMode = false
        },
        typescript = {
            tsdk = vim.fn.stdpath('data') ..'/mason/packages/vue-language-server/node_modules/typescript/lib/'
        }
    }
}
