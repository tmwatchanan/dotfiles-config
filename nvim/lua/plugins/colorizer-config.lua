local M = {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre'
}

M.opts = {
    user_default_options = {
        css = true,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        names = false,
        mode = 'virtualtext',
        virtualtext = '󱓻',
        virtualtext_inline = true,
    },
    filetypes = {
        'html',
        'css',
        'scss',
        'javascript',
        'typescript',
        'tsx',
        'vue',
        'svelte'
    },
}

return M
