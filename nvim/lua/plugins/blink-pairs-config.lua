local M = {
    'saghen/blink.pairs',
    build = function(plugin)
        local fn_utils = require('config.fn-utils')
        fn_utils.jobstart({ 'cargo', 'build', '--release' }, {
            cwd = plugin.path,
            title = 'blink.pairs',
        })
    end,
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
