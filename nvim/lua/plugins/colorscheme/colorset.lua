local M = {}

M.colors = {
    white       = '#d4be98',
    gray        = '#928374',
    black       = '#21252B',
    red         = '#ea6962',
    green       = '#a9b665',
    blue        = '#7daea3',
    bright_blue = '#1085FF',
    yellow      = '#d8a657',
    orange      = '#e78a4e',
    purple      = '#af5fff',
    magenta     = '#d3869b',
    teal        = '#5bc8af',
    cyan        = '#89b482',
    bg          = '#1d2021',
    bg_storm    = '#202528',
    bg0         = '#282828',
    bg1         = '#3c3836',
    bg2         = '#504945',
    bg3         = '#665c54',
    transparent = 'NONE',
    error       = '#c53b53',
    warn        = '#ffc777',
    info        = '#0db9d7',
    hint        = '#4fd6be',
}

M.bracket = {
    '#ffd700',
    '#da70d6',
    '#2ac3de',
}

M.todocomments = {
    error = M.colors.error,
    warn  = M.colors.warn,
    info  = M.colors.info,
    hint  = M.colors.hint,
    perf  = '#1085FF',
    todo  = '#B57EDC',
    hack  = '#D19A66',
}

M.lualine = {
    a = { bg = M.colors.transparent, gui = 'bold' },
    b = { fg = M.colors.white, bg = M.colors.transparent },
    c = { fg = M.colors.white, bg = M.colors.transparent },
}


return M
