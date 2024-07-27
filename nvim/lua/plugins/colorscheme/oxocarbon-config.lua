local M = {}

M.setup = function()
    local oxocarbon_status, oxocarbon = pcall(require, 'oxocarbon')
    if oxocarbon_status then
        local colorset = require('plugins.colorscheme.colorset').colors
        local utils = require('config.fn-utils')

        vim.opt.background = 'dark'
        vim.cmd.colorscheme 'oxocarbon'

        local overrided_highlights = {}
        local c = oxocarbon.oxocarbon

        local incline_highlight = {
            InclineNormal = { bg = c.none, bold = true },
            InclineNormalNC = { fg = c.base03, bg = c.none },
        }

        local noice_highlight = {
            NoiceCmdlineIconCmdline = { link = 'lualine_a_command' },
            NoiceCmdlineIconSearch = { link = 'lualine_a_command' },
            NoiceCmdlineIconFilter = { link = 'lualine_a_command' },
        }

        local telescope_highlight = {
            TelescopeNormal = { fg = c.base03, bg = c.base00 },
            TelescopeSelection = { fg = c.base06, bold = true },
            TelescopeSelectionCaret = { fg = c.base10, bold = true },
            TelescopeMultiSelection = { fg = '#ffaa00' },
            TelescopeMultiIcon = { fg = '#ffaa00' },
            TelescopePromptNormal = { fg = c.base04, bg = c.base01 },
            TelescopePromptPrefix = { fg = c.base08, bg = c.base01 },
            TelescopePromptBorder = { bg = c.base01 },
            TelescopeResultsNormal = { bg = c.base01 },
            TelescopeResultsBorder = { bg = c.base01 },
            TelescopePreviewNormal = { bg = c.base01 },
            TelescopePreviewBorder = { bg = c.base01 },
            TelescopePreviewLine = { bg = c.base02 },
            TelescopeResultsTitle = { fg = c.base03 },
            TelescopeMatching = { fg = c.base12, bold = true },
            TelescopeResultsDiffAdd = { bg = c.base01 },
            TelescopeResultsDiffChange = { bg = c.base01 },
            TelescopeResultsDiffDelete = { bg = c.base01 },
            TelescopeResultsDiffUntracked = { bg = c.base01 }
        }

        local flit_highlight = {
            LeapBackdrop = { fg = c.base03, bg = c.none },
            LeapLabel = { fg = colorset.purple, bold = true, nocombine = true },
            LeapMatch = { fg = 'white', bold = true, nocombine = true },
        }

        local diagnostic_highlight = {
            DiagnosticError = { fg = colorset.error },
            DiagnosticWarn = { fg = colorset.warn },
            DiagnosticInfo = { fg = colorset.info },
            DiagnosticHint = { fg = colorset.hint },
            DiagnosticUnderlineError = { fg = colorset.error, undercurl = true },
            DiagnosticUnderlineWarn = { fg = colorset.warn, undercurl = true },
            DiagnosticUnderlineInfo = { fg = colorset.info, undercurl = true },
            DiagnosticUnderlineHint = { fg = colorset.hint, undercurl = true },
            DiagnosticVirtualTextError = { bg = '#322639', fg = colorset.error, italic = true },
            DiagnosticVirtualTextWarn = { bg = '#38343d', fg = colorset.warn, italic = true },
            DiagnosticVirtualTextInfo = { bg = '#203346', fg = colorset.info, italic = true },
            DiagnosticVirtualTextHint = { bg = '#273644', fg = colorset.hint, italic = true },
        }

        local rainbow_delimiter_highlight = {
            RainbowDelimiterRed = { fg = c.base10 },
            RainbowDelimiterBlue = { fg = c.base11 },
            RainbowDelimiterCyan = { fg = c.base08 },
            RainbowDelimiterGreen = { fg = c.base13 },
            RainbowDelimiterYellow = { fg = '#FFAB91' },
            RainbowDelimiterOrange = { fg = '#FF6F00' },
            RainbowDelimiterViolet = { fg = c.base14 },
        }

        local treesitter_context_highlight = {
            TreesitterContext = { bg = c.none, bold = true },
            TreesitterContextLineNumber = { link = 'TreesitterContext' },
        }

        local cmp_highlight = {
            CmpItemAbbrDeprecated = { fg = c.base03, bg = c.none, strikethrough = true },
            CmpItemAbbrMatch = { fg = c.base05, bg = c.none, bold = true },
            CmpItemAbbrMatchFuzzy = { fg = c.base05, bg = c.none, bold = true },
            CmpItemMenu = { fg = c.base10, bg = c.none, italic = true },
            CmpItemKindInterface = { fg = c.base08, bg = c.none },
            CmpItemKindColor = { fg = c.base08, bg = c.none },
            CmpItemKindTypeParameter = { fg = c.base08, bg = c.none },
            CmpItemKindText = { fg = c.base09, bg = c.none },
            CmpItemKindEnum = { fg = c.base09, bg = c.none },
            CmpItemKindKeyword = { fg = c.base09, bg = c.none },
            CmpItemKindConstant = { fg = c.base10, bg = c.none },
            CmpItemKindConstructor = { fg = c.base10, bg = c.none },
            CmpItemKindReference = { fg = c.base10, bg = c.none },
            CmpItemKindFunction = { fg = c.base11, bg = c.none },
            CmpItemKindStruct = { fg = c.base11, bg = c.none },
            CmpItemKindClass = { fg = c.base11, bg = c.none },
            CmpItemKindModule = { fg = c.base11, bg = c.none },
            CmpItemKindOperator = { fg = c.base11, bg = c.none },
            CmpItemKindField = { fg = c.base12, bg = c.none },
            CmpItemKindProperty = { fg = c.base12, bg = c.none },
            CmpItemKindEvent = { fg = c.base12, bg = c.none },
            CmpItemKindUnit = { fg = c.base13, bg = c.none },
            CmpItemKindSnippet = { fg = c.base13, bg = c.none },
            CmpItemKindFolder = { fg = c.base13, bg = c.none },
            CmpItemKindVariable = { fg = c.base14, bg = c.none },
            CmpItemKindFile = { fg = c.base14, bg = c.none },
            CmpItemKindMethod = { fg = c.base15, bg = c.none },
            CmpItemKindValue = { fg = c.base15, bg = c.none },
            CmpItemKindEnumMember = { fg = c.base15, bg = c.none },
        }

        local hlslens_highlight = {
            HlSearchLens = { link = 'PmenuSel' },
        }

        local indentscope_highlight = {
            MiniIndentscopeSymbol = { fg = c.base04, bg = c.none },
        }

        local marks_highlight = {
            MarkSignHL = { fg = colorset.bright_blue },
        }

        overrided_highlights = utils.merge(overrided_highlights, {
            Normal = { fg = c.base04, bg = c.none },
            NormalNC = { fg = c.base04, bg = c.none },
            LineNr = { fg = c.base03, bg = c.none },
            FoldColumn = { fg = c.base02, bg = c.none },
            SignColumn = { fg = c.base02, bg = c.none },
            CursorLine = { bg = c.base02 },
            VertSplit = { fg = c.base02, bg = c.none },
            NormalFloat = { bg = c.base01 },
            FloatBorder = { link = 'NormalFloat' },
            FloatTitle = { fg = c.base10, bg = c.base01, bold = true },
            Pmenu = { fg = c.base04, bg = c.base00 },
            PmenuSel = { fg = c.none, bg = c.base02 },
            Search = { fg = c.base01, bg = c.base12, bold = true },
            WinSeparator = { fg = c.base03, bg = c.none },
            LspInlayHint = { fg = c.base03, bg = c.none, italic = true },
            LspReferenceText = { bg = c.base02 },
            LspReferenceRead = { link = 'LspReferenceText' },
            LspReferenceWrite = { link = 'LspReferenceText' },
        })
        overrided_highlights = utils.merge(overrided_highlights, telescope_highlight)
        overrided_highlights = utils.merge(overrided_highlights, incline_highlight)
        overrided_highlights = utils.merge(overrided_highlights, noice_highlight)
        overrided_highlights = utils.merge(overrided_highlights, flit_highlight)
        overrided_highlights = utils.merge(overrided_highlights, diagnostic_highlight)
        overrided_highlights = utils.merge(overrided_highlights, rainbow_delimiter_highlight)
        overrided_highlights = utils.merge(overrided_highlights, treesitter_context_highlight)
        overrided_highlights = utils.merge(overrided_highlights, cmp_highlight)
        overrided_highlights = utils.merge(overrided_highlights, hlslens_highlight)
        overrided_highlights = utils.merge(overrided_highlights, indentscope_highlight)
        overrided_highlights = utils.merge(overrided_highlights, marks_highlight)

        for hl_name, hl_value in pairs(overrided_highlights) do
            vim.api.nvim_set_hl(0, hl_name, hl_value)
        end

        -- INFO: overrided some terminal colors
        vim.g['terminal_color_3'] = c.base10
        vim.g['terminal_color_5'] = '#ffab91'
        vim.g['terminal_color_9'] = c.base15
        vim.g['terminal_color_11'] = c.base12
        vim.g['terminal_color_13'] = '#ff6f00'
    end
end

M.lualine = function()
    local oxocarbon_status, oxocarbon = pcall(require, 'oxocarbon')
    if not oxocarbon_status then
        return
    end

    local utils = require('config.fn-utils')
    local lualine_default = require('plugins.colorscheme.colorset').lualine
    local c = oxocarbon.oxocarbon

    return {
        normal = utils.deep_merge(lualine_default, {
            a = { fg = c.base08 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
        insert = utils.deep_merge(lualine_default, {
            a = { fg = c.base10 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
        visual = utils.deep_merge(lualine_default, {
            a = { fg = c.base14 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
        replace = utils.deep_merge(lualine_default, {
            a = { fg = c.base11 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
        command = utils.deep_merge(lualine_default, {
            a = { fg = c.base12 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
    }
end

return M
