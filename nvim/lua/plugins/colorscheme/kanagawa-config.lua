local M = {}

M.setup = function()
    local kanagawa_status, kanagawa = pcall(require, 'kanagawa')
    if kanagawa_status then
        local colorset = require('plugins.colorscheme.colorset').colors
        local utils = require('config.fn-utils')

        vim.opt.background = 'dark'
        vim.cmd.colorscheme 'kanagawa'

        local colors = require("kanagawa.colors").setup()
        local palette = colors.palette

        local overrided_highlights = {}

        local incline_highlight = {
            InclineNormal = {
                fg = vim.o.background ~= 'dark' and colorset.black or colorset.white,
                bg = colorset.transparent,
                bold = true
            },
            InclineNormalNC = { fg = colorset.gray, bg = colorset.transparent, },
        }

        local noice_highlight = {
            NoiceCmdlineIconCmdline = { link = 'lualine_a_command' },
            NoiceCmdlineIconSearch = { link = 'lualine_a_command' },
            NoiceCmdlineIconFilter = { link = 'lualine_a_command' },
        }

        local telescope_highlight = {
            TelescopeBorder = { bg = colorset.transparent },
        }

        local rainbow_delimiter_highlight = {
            RainbowDelimiterRed = { fg = palette.springViolet2 },
            RainbowDelimiterYellow = { fg = palette.dragonBlue },
            RainbowDelimiterBlue = { fg = palette.springGreen },
            RainbowDelimiterOrange = { fg = palette.waveAqua2 },
            RainbowDelimiterGreen = { fg = palette.springViolet1 },
            RainbowDelimiterViolet = { fg = palette.carpYellow },
            RainbowDelimiterCyan = { fg = palette.waveRed },
        }

        local treesitter_context_highlight = {
            TreesitterContext = { bg = 'none', bold = true },
        }

        local hlslens_highlight = {
            HlSearchLens = { link = 'PmenuSel' },
        }

        local marks_highlight = {
            MarkSignHL = { fg = colorset.bright_blue },
            -- MarkVirtTextHL = { fg = colorset.bright_blue, bg = colorset.transparent, nocombine = true },
        }

        overrided_highlights = utils.merge(overrided_highlights, {
            NormalNC = { bg = colorset.transparent }, -- transparent for terminal
            -- NormalFloat = { bg = colorset.transparent },
            WinSeparator = { fg = palette.springViolet1, bg = colorset.transparent },
            LspReferenceWrite = { underline = false }, -- cursor hover
        })
        overrided_highlights = utils.merge(overrided_highlights, telescope_highlight)
        overrided_highlights = utils.merge(overrided_highlights, incline_highlight)
        overrided_highlights = utils.merge(overrided_highlights, noice_highlight)
        overrided_highlights = utils.merge(overrided_highlights, rainbow_delimiter_highlight)
        overrided_highlights = utils.merge(overrided_highlights, treesitter_context_highlight)
        overrided_highlights = utils.merge(overrided_highlights, hlslens_highlight)
        overrided_highlights = utils.merge(overrided_highlights, marks_highlight)

        for hl_name, hl_value in pairs(overrided_highlights) do
            vim.api.nvim_set_hl(0, hl_name, hl_value)
        end

        kanagawa.setup {
            compile = false,
            transparent = true,
            globalStatus = true,
            dimInactive = true,
            terminalColors = false,
            colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = colorset.transparent,
                        }
                    }
                }
            },
            overrides = function(_) return overrided_highlights end,
        }
        kanagawa.load('wave')
    end
end

M.lualine = function()
    local kanagawa_status, _ = pcall(require, 'kanagawa')
    if not kanagawa_status then
        return
    end

    local colorset = require('plugins.colorscheme.colorset').colors
    local theme = require("kanagawa.colors").setup().theme

    local kanagawa = {}

    kanagawa.normal = {
        a = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
        b = { bg = theme.diff.change, fg = theme.syn.fun },
        c = { bg = colorset.transparent, fg = theme.ui.fg },
    }

    kanagawa.insert = {
        a = { bg = theme.diag.ok, fg = theme.ui.bg },
        b = { bg = theme.ui.bg, fg = theme.diag.ok },
    }

    kanagawa.command = {
        a = { bg = theme.syn.operator, fg = theme.ui.bg },
        b = { bg = theme.ui.bg, fg = theme.syn.operator },
    }

    kanagawa.visual = {
        a = { bg = theme.syn.keyword, fg = theme.ui.bg },
        b = { bg = theme.ui.bg, fg = theme.syn.keyword },
    }

    kanagawa.replace = {
        a = { bg = theme.syn.constant, fg = theme.ui.bg },
        b = { bg = theme.ui.bg, fg = theme.syn.constant },
    }

    kanagawa.inactive = {
        a = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        b = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim, gui = "bold" },
        c = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    }

    if vim.g.kanagawa_lualine_bold then
        for _, mode in pairs(kanagawa) do
            mode.a.gui = "bold"
        end
    end

    return kanagawa
end

return M
