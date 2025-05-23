local copilot = {
    'zbirenbaum/copilot.lua',
    event = 'LspAttach',
    cmd = 'Copilot',
    cond = not vim.g.vscode,
}

copilot.opts = function()
    local copilot_keymap = require('config.keymaps').copilot

    -- INFO: hide copilot suggestion if blink cmp is visible
    vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpShow',
        callback = function()
            vim.b.copilot_suggestion_hidden = true
        end,
    })
    vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpHide',
        callback = function()
            vim.b.copilot_suggestion_hidden = false
        end,
    })

    return {
        suggestion = {
            auto_trigger = true,
            hide_during_completion = true,
            keymap = {
                accept = false,
                dismiss = false,
                next = copilot_keymap.next,
                prev = copilot_keymap.prev,
            },
        },
        panel = { enabled = false },
    }
end

local codecompanion = {
    'olimorris/codecompanion.nvim',
    dependencies = { 'plenary.nvim', 'nvim-treesitter', { 'echasnovski/mini.diff', opts = {} } },
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
}

codecompanion.opts = {
    adapters = {
        copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
                schema = {
                    model = {
                        default = 'claude-3.7-sonnet',
                    },
                },
            })
        end,
    },
    strategies = {
        chat = {
            adapter = 'copilot',
            keymaps = {
                close = {
                    modes = { n = 'Q' }
                },
                stop = {
                    modes = { n = '<C-c>', i = '<C-c>' },
                },
                toggle = {
                    modes = { n = 'q' },
                    callback = function()
                        require('codecompanion').toggle()
                    end,
                    description = 'Toggle Chat',
                },
            },
        },
        inline = { adapter = 'copilot' },
    },
    display = {
        chat = {
            intro_message = '',
            show_settings = true,
            window = {
                layout   = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
                -- width = 1,
                -- height = 0.45,
                width    = 0.3,
                height   = vim.o.lines - 3,

                -- Options below only apply to floating windows
                relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
                border   = 'solid',
                -- row = vim.o.lines - (math.floor(0.45 * vim.o.lines)) - 3, -- INFO: `-3` is from -1 statusline and -2 from border top-bottom
                row      = 0,
                col      = vim.o.columns,
                title    = ' Code Companion ',
                opts     = {
                    winhighlight = 'Normal:NormalFloat,NormalNC:NormalFloatNC',
                }
            },
        },
        diff = { provider = 'mini_diff' },
    },
}

codecompanion.keys = function()
    local codecompanion_keymap = require('config.keymaps').codecompanion

    return {
        { codecompanion_keymap.chat,   '<Cmd>CodeCompanionChat<CR>',        mode = { 'n' }, desc = 'CodeCompanion - New Chat' },
        { codecompanion_keymap.toggle, '<Cmd>CodeCompanionChat Toggle<CR>', mode = { 'n' }, desc = 'CodeCompanion - Toggle Chat' },
        { codecompanion_keymap.toggle, ':CodeCompanionChat Add<CR>',        mode = { 'v' }, desc = 'CodeCompanion - Add to Chat' },
        { codecompanion_keymap.inline, ':CodeCompanion ',                   mode = { 'v' }, desc = 'CodeCompanion - Inline Chat' },
    }
end

return {
    copilot,
    codecompanion,
}
