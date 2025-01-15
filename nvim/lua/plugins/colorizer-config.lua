local M = {
    'NvChad/nvim-colorizer.lua',
    event = 'VeryLazy'
}

M.opts = {
    lazy_load = true,
    user_default_options = {
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        RGB = false,
        RGBA = false,
        names = false,
        mode = 'virtualtext',
        virtualtext = '󱓻',
        virtualtext_inline = true,
    },
}

return M
