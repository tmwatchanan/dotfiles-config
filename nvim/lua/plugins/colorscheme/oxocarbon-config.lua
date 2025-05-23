local M = {}

M.info = { 'nyoom-engineering/oxocarbon.nvim' }

M.setup = function()
    local oxocarbon_status, oxocarbon = pcall(require, 'oxocarbon')
    if not oxocarbon_status then return end

    local colorset = require('plugins.colorscheme.colorset').colors
    local utils = require('config.fn-utils')

    vim.opt.background = 'dark'
    vim.cmd.colorscheme 'oxocarbon'

    local overrided_highlights = {}
    local c = oxocarbon.oxocarbon
    local winblend = vim.opt.winblend:get()

    -- INFO: extends new colors
    c.pink = '#f38ba8'
    c.orange = '#f9b387'
    c.yellow = '#f9e2af'
    c.green = '#a6e3a1'
    c.blue = '#74c7ec'
    c.periwinkle = '#b4befe'
    c.lavender = '#cba6f7'

    c.float_bg = '#232323'
    c.ghost = '#808080'

    local incline_highlight = {
        InclineNormal = { fg = c.base04, bg = c.none, blend = 0 },
        InclineNormalNC = { fg = c.base03, bg = c.none, blend = 0 },
    }

    local noice_highlight = {
        NoiceCmdlineIconCmdline = { link = 'lualine_a_command' },
        NoiceCmdlineIconSearch = { link = 'lualine_a_command' },
        NoiceCmdlineIconFilter = { link = 'lualine_a_command' },
        NoiceSplit = { link = 'Normal' },
        NoiceSplitBorder = { link = 'NoiceSplit' },
    }

    local snacks_highlight = {
        SnacksPicker = { bg = c.float_bg, blend = winblend },
        SnacksPickerBorder = { bg = c.float_bg, blend = winblend },
        SnacksPickerTitle = { fg = c.float_bg, bg = c.base12, bold = true, blend = winblend },
        SnacksPickerPreview = { bg = c.base00, blend = winblend },
        SnacksPickerPreviewBorder = { bg = c.base00, blend = winblend },
        SnacksPickerPreviewTitle = { fg = c.base00, bg = c.base10, bold = true, blend = winblend },
        SnacksPickerDir = { fg = c.base03 },
        SnacksPickerTotals = { fg = c.base03 },
        SnacksPickerSelected = { fg = c.orange },
        SnacksPickerMatch = { fg = c.base12, bold = true },
        SnacksTerminalNormal = { bg = c.none },
        SnacksTerminalBorder = { link = 'SnacksTerminalNormal' },
        SnacksTerminalFooter = { fg = c.base10, bg = c.none, bold = true }
    }

    local markdown_highlight = {
        ['@markup.heading.1.markdown'] = { fg = c.pink },
        ['@markup.heading.2.markdown'] = { fg = c.orange },
        ['@markup.heading.3.markdown'] = { fg =  c.yellow },
        ['@markup.heading.4.markdown'] = { fg = c.green },
        ['@markup.heading.5.markdown'] = { fg = c.blue },
        ['@markup.heading.6.markdown'] = { fg =  c.periwinkle},
        ['@markup.heading.7.markdown'] = { fg =  c.lavender },
    }

    local oil_highlight = {
        OilTitle = { fg = c.base00, bg = c.base12, bold = true },
        OilPreviewNormal = { bg = c.base00 },
        OilPreviewBorder = { bg = c.base00 },
        OilPreviewTitle = { fg = c.base00, bg = c.base10, bold = true }
    }

    local flit_highlight = {
        LeapBackdrop = { fg = c.base03, bg = c.none },
        LeapLabel = { fg = colorset.purple, bold = true, nocombine = true },
        LeapMatch = { fg = c.base04, bold = true, nocombine = true },
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
        TreesitterContext = { bg = c.none, bold = true, blend = 0 },
        TreesitterContextLineNumber = { link = 'TreesitterContext' },
    }

    local cmp_highlight = {
        CmpItemAbbrDeprecated = { fg = c.base03, bg = c.none, strikethrough = true },
        CmpItemAbbrMatch = { fg = c.base05, bg = c.none, bold = true },
        CmpItemAbbrMatchFuzzy = { fg = c.base05, bg = c.none, bold = true },
        CmpItemMenu = { fg = c.base10, bg = c.none, italic = true },
        CmpGhostText = { fg = c.ghost },
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

    local marks_highlight = {
        MarkSignHL = { fg = colorset.bright_blue },
    }

    local surround_highlight = {
        MiniSurround = { link = 'MatchParen' },
    }

    overrided_highlights = utils.merge(overrided_highlights, {
        Normal = { fg = c.base04, bg = c.none },
        NormalNC = { link = 'Normal' },
        LineNr = { fg = c.base03, bg = c.none },
        FoldColumn = { fg = c.base02, bg = c.none },
        SignColumn = { fg = c.base02, bg = c.none },
        CursorLine = { bg = c.base02 },
        VertSplit = { fg = c.base02, bg = c.none },
        StatusLine = { bg = c.none },
        NormalFloat = { bg = c.float_bg },
        NormalFloatNC = { link = 'NormalFloat' },
        FloatBorder = { link = 'NormalFloat' },
        FloatTitle = { fg = c.base10, bg = c.float_bg, bold = true },
        Pmenu = { fg = c.base04, bg = c.float_bg, blend = vim.opt.pumblend:get() },
        PmenuSel = { fg = c.none, bg = c.base02 },
        Search = { fg = c.base01, bg = c.base12, bold = true },
        WinSeparator = { fg = c.base03, bg = c.none },
        LspInlayHint = { fg = c.base03, bg = c.none, italic = true },
        LspReferenceText = { bg = c.base02 },
        LspReferenceRead = { link = 'LspReferenceText' },
        LspReferenceWrite = { link = 'LspReferenceText' },
    })
    overrided_highlights = utils.merge(overrided_highlights, incline_highlight)
    overrided_highlights = utils.merge(overrided_highlights, noice_highlight)
    overrided_highlights = utils.merge(overrided_highlights, flit_highlight)
    overrided_highlights = utils.merge(overrided_highlights, diagnostic_highlight)
    overrided_highlights = utils.merge(overrided_highlights, rainbow_delimiter_highlight)
    overrided_highlights = utils.merge(overrided_highlights, treesitter_context_highlight)
    overrided_highlights = utils.merge(overrided_highlights, cmp_highlight)
    overrided_highlights = utils.merge(overrided_highlights, hlslens_highlight)
    overrided_highlights = utils.merge(overrided_highlights, marks_highlight)
    overrided_highlights = utils.merge(overrided_highlights, oil_highlight)
    overrided_highlights = utils.merge(overrided_highlights, snacks_highlight)
    overrided_highlights = utils.merge(overrided_highlights, markdown_highlight)
    overrided_highlights = utils.merge(overrided_highlights, surround_highlight)

    for hl_name, hl_value in pairs(overrided_highlights) do
        vim.api.nvim_set_hl(0, hl_name, hl_value)
    end

    -- INFO: overrided terminal colors
    vim.g['terminal_color_0'] = c.base01
    vim.g['terminal_color_1'] = c.base07
    vim.g['terminal_color_2'] = c.base11
    vim.g['terminal_color_3'] = c.base10
    vim.g['terminal_color_4'] = c.base13
    vim.g['terminal_color_5'] = c.base14
    vim.g['terminal_color_6'] = c.base10
    vim.g['terminal_color_7'] = c.base05

    vim.g['terminal_color_8'] = c.base03
    vim.g['terminal_color_9'] = c.base08
    vim.g['terminal_color_10'] = c.base15
    vim.g['terminal_color_11'] = c.base12
    vim.g['terminal_color_12'] = c.base13
    vim.g['terminal_color_13'] = c.base14
    vim.g['terminal_color_14'] = c.base12
    vim.g['terminal_color_15'] = c.base06
end

M.lualine = function()
    local oxocarbon_status, oxocarbon = pcall(require, 'oxocarbon')
    if not oxocarbon_status then return end

    local utils = require('config.fn-utils')
    local lualine_default = require('plugins.colorscheme.colorset').lualine
    local c = oxocarbon.oxocarbon

    return {
        normal = utils.deep_merge(lualine_default, {
            a = { fg = c.base10 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
        insert = utils.deep_merge(lualine_default, {
            a = { fg = c.base13 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
        visual = utils.deep_merge(lualine_default, {
            a = { fg = c.base14 },
            b = { fg = c.base04 },
            c = { fg = c.base04 },
        }),
        replace = utils.deep_merge(lualine_default, {
            a = { fg = c.base08 },
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

M.colors = function()
    local oxocarbon_status, oxocarbon = pcall(require, 'oxocarbon')
    if not oxocarbon_status then return {} end

    return oxocarbon.oxocarbon
end

return M
