local M = {
    'saghen/blink.pairs',
    build = function()
        require('blink.pairs').build():pwait()
    end,
    dependencies = {
        { 'saghen/blink.lib' },
    }
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
