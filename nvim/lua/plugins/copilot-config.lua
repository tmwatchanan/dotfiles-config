local M = {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = 'Copilot',
}

M.opts = {
    panel = {
        keymap = {
            refresh = '<M-r>'
        },
        layout = {
            ratio = 0.33
        }
    },
    suggestion = {
        auto_trigger = true,
        keymap = {
            accept = '<C-l>',
            next = '<C-j>',
            prev = '<C-k>',
            dismiss = false,
        }
    },
}

return M
