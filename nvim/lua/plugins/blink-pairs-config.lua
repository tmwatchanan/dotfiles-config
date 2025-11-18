local M = {
    'saghen/blink.pairs',
    build = 'cargo build --release',
}

M.opts = {
    mappings = {
        cmdline = false,
    },
    highlights = {
        groups = {
            'BlinkPairsRed',
            'BlinkPairsYellow',
            'BlinkPairsBlue',
            'BlinkPairsOrange',
            'BlinkPairsGreen',
            'BlinkPairsViolet',
            'BlinkPairsCyan',
        },
        matchparen = { include_surrounding = true },
    }
}

return M
