local M = {}

M.info = { 'scottmckendry/cyberdream.nvim', colorscheme = 'cyberdream' }

M.setup = function()
    local cyberdream_status, cyberdream = pcall(require, 'cyberdream')
    if not cyberdream_status then return end

    vim.opt.background = 'dark'

    -- Zed's terminal follows the (possibly light) Zed UI theme, so a
    -- transparent background bleeds it through the dark colorscheme.
    -- Paint our own background there; stay transparent elsewhere.
    local transparent = vim.env.ZED_TERM ~= 'true'

    cyberdream.setup {
        transparent = transparent,
        italic_comments = true,
        hide_fillchars = false,
        borderless_pickers = false,
        terminal_colors = false,
        theme = {
            variant = 'default',
        },
    }

    vim.cmd.colorscheme 'cyberdream'

    -- cyberdream's `theme.overrides` only mutate groups it already defines;
    -- custom groups (BlinkPairs*, RainbowDelimiter*, Incline*) must be set
    -- directly so consumers like indent-blankline find them at load time.
    local colors = require('cyberdream.colors').default
    local overrided_highlights = {
        WinSeparator = { fg = colors.purple },
        LspReferenceWrite = { underline = false }, -- cursor hover

        HlSearchLens = { link = 'PmenuSel' },

        InclineNormal = { fg = colors.fg, bold = true },
        InclineNormalNC = { fg = colors.grey },

        TreesitterContext = { link = 'Folded' },
        TreesitterContextLineNumber = { link = 'Folded' },

        NoiceCmdlineIconCmdline = { link = 'lualine_a_command' },
        NoiceCmdlineIconSearch = { link = 'lualine_a_command' },
        NoiceCmdlineIconFilter = { link = 'lualine_a_command' },

        RainbowDelimiterRed = { fg = colors.red },
        RainbowDelimiterYellow = { fg = colors.yellow },
        RainbowDelimiterBlue = { fg = colors.blue },
        RainbowDelimiterOrange = { fg = colors.orange },
        RainbowDelimiterGreen = { fg = colors.green },
        RainbowDelimiterViolet = { fg = colors.purple },
        RainbowDelimiterCyan = { fg = colors.cyan },

        BlinkPairsRed = { fg = colors.red },
        BlinkPairsBlue = { fg = colors.blue },
        BlinkPairsCyan = { fg = colors.cyan },
        BlinkPairsGreen = { fg = colors.green },
        BlinkPairsYellow = { fg = colors.yellow },
        BlinkPairsOrange = { fg = colors.orange },
        BlinkPairsViolet = { fg = colors.purple },

        MarkSignHL = { fg = colors.blue },
    }

    for hl_name, hl_value in pairs(overrided_highlights) do
        vim.api.nvim_set_hl(0, hl_name, hl_value)
    end
end

M.lualine = function()
    return 'cyberdream'
end

M.colors = function()
    local colors_status, colors = pcall(require, 'cyberdream.colors')
    if not colors_status then return {} end

    return colors.default or colors
end

return M
