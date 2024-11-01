local M = {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    cond = not vim.g.vscode,
}

M.opts = {
    debugger = {
        enabled = true,
        run_via_dap = false,
    },
    closing_tags = {
        prefix = "> ",
    },
    lsp = {
        color = { -- show the derived colours for dart variables
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = true, -- highlight the background
            background_color = { r = 19, g = 17, b = 24 }, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = false, -- highlight the foreground
            virtual_text = false, -- show the highlight using virtual text
            virtual_text_str = "■", -- the virtual text character to highlight
        },
    },
}

M.keys = function()
    local keymap = require('config.keymaps').flutter_tools
    return {
        { keymap.run,            '<Cmd>FlutterRun<CR>' },
        { keymap.quit,           '<Cmd>FlutterQuit<CR>' },
        { keymap.devices,        '<Cmd>FlutterDevices<CR>' },
        { keymap.detach,         '<Cmd>FlutterDetach<CR>' },
        { keymap.emulators,      '<Cmd>FlutterEmulators<CR>' },
        { keymap.reload,         '<Cmd>FlutterReload<CR>' },
        { keymap.restart,        '<Cmd>FlutterRestart<CR>' },
        { keymap.rename,         '<Cmd>FlutterRename<CR>' },
        { keymap.outline_toggle, '<Cmd>FlutterOutlineToggle<CR>' },
        { keymap.visual_debug,   '<Cmd>FlutterVisualDebug<CR>' },
    }
end



return M
