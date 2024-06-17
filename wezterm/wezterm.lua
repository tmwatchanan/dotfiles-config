local wezterm = require 'wezterm'
local config = {}

config.colors = {
    background   = '#262626',
    foreground   = '#ffffff',
    selection_bg = '#33b1ff',
    selection_fg = ' #ffffff',
    cursor_bg    = '#f2f2f2',
    cursor_fg    = '#262626',
    ansi         = {
        '#262626',
        '#33b1ff',
        '#be95ff',
        '#ee5396',
        '#78a9ff',
        '#ffab91',
        '#3ddbd9',
        '#f2f2f2',
    },
    brights      = {
        '#525252',
        '#82cfff',
        '#be95ff',
        '#ff7eb6',
        '78a9ff',
        '#ff6f00',
        '#08bdba',
        '#ffffff',
    },
}

config.font = wezterm.font('Maple Mono NF', { weight = 'SemiBold' })
config.font_size = 13
config.line_height = 1.1

config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = 0,
}

config.enable_tab_bar = false
config.window_decorations = 'RESIZE'
config.audible_bell = 'Disabled'


return config
