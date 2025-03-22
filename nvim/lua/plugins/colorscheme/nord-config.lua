local M = {}

M.info = { 'gbprod/nord.nvim' }

M.setup = function()
    local nord_status, nord = pcall(require, 'nord')
    if not nord_status then return end
    local colorset = require('plugins.colorscheme.colorset').colors

    vim.opt.background = 'dark'
    vim.g.kanagawa_lualine_bold = true

    local function apply_highlights(highlights, overrided_highlights)
        for hl, attr in pairs(overrided_highlights) do
            highlights[hl] = attr
        end
    end

    nord.setup {
        on_highlights = function(highlights, palette)
            local overrided_highlights = {
                RainbowDelimiterRed = { fg = palette.snow_storm.origin },
                RainbowDelimiterYellow = { fg = palette.frost.ice },
                RainbowDelimiterBlue = { fg = palette.aurora.orange },
                RainbowDelimiterOrange = { fg = palette.aurora.green },
                RainbowDelimiterGreen = { fg = palette.frost.artic_ocean },
                RainbowDelimiterViolet = { fg = palette.aurora.yellow },
                RainbowDelimiterCyan = { fg = palette.aurora.red },

                HlSearchLens = { link = 'PmenuSel' },

                InclineNormal = { fg = palette.frost.artic_water, bold = true },
                TreesitterContext = { link = 'Folded' },
                TreesitterContextLineNumber = { link = 'Folded' },
            }
            apply_highlights(highlights, overrided_highlights)

            local semantic_token_highlights = {
                ['@string'] = { fg = palette.aurora.purple },
                ['@lsp.type.decorator'] = { fg = palette.aurora.yellow },
                ['@function'] = { fg = palette.aurora.yellow },
                ['@function.method'] = { fg = palette.aurora.yellow },
                ['@function.method.call'] = { fg = palette.aurora.yellow },
                ['@module'] = { fg = palette.aurora.green },
                ['@type'] = { fg = palette.frost.artic_ocean },
                ['@variable.parameter'] = { fg = palette.snow_storm.origin, italic = true },

                ['@keyword'] = { fg = palette.frost.polar_water, italic = true },
                ['@keyword.function'] = { link = '@keyword' },
                ['@keyword.operator'] = { link = '@keyword' },
                ["@keyword.return"] = { link = '@keyword' },
                ["@keyword.conditional"] = { link = '@keyword' },
                ["@keyword.repeat"] = { link = '@keyword' },
                ["@keyword.import"] = { link = '@keyword' },
                ["@keyword.exception"] = { link = '@keyword' },
            }
            apply_highlights(highlights, semantic_token_highlights)
        end,
    }
    vim.cmd.colorscheme 'nord'
    local defaults = {
        polar_night = {
            origin = "#2E3440",    -- nord0
            bright = "#3B4252",    -- nord1
            brighter = "#434C5E",  -- nord2
            brightest = "#4C566A", -- nord3
            light = "#616E88",     -- out of palette
        },
        snow_storm = {
            origin = "#D8DEE9",    -- nord4
            brighter = "#E5E9F0",  -- nord5
            brightest = "#ECEFF4", -- nord6
        },
        frost = {
            polar_water = "#8FBCBB", -- nord7
            ice = "#88C0D0",         -- nord8
            artic_water = "#81A1C1", -- nord9
            artic_ocean = "#5E81AC", -- nord10
        },
        aurora = {
            red = "#BF616A",    -- nord11
            orange = "#D08770", -- nord12
            yellow = "#EBCB8B", -- nord13
            green = "#A3BE8C",  -- nord14
            purple = "#B48EAD", -- nord15
        },
        none = "NONE",
    }
end

M.lualine = function()
    return 'nord'
end

M.colors = function()
    local nord_status, nord = pcall(require, 'nord')
    if not nord_status then return {} end

    local colors = require('nord.colors')
    return colors.palette
end

return M
