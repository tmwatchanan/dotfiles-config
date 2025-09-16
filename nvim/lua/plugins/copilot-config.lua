local copilot = {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
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
            auto_trigger = false,
            hide_during_completion = true,
            keymap = {
                accept = false,
                dismiss = false,
                next = copilot_keymap.next,
                prev = copilot_keymap.prev,
            },
        },
        panel = { enabled = false },
        server_opts_overrides = {
            settings = {
                telemetry = { telemetryLevel = 'off' }
            }
        }
    }
end

local codecompanion = {
    'olimorris/codecompanion.nvim',
    dependencies = {
        'plenary.nvim',
        'nvim-treesitter',
        'ravitemer/codecompanion-history.nvim',
    },
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
}

codecompanion.opts = {
    adapters = {
        http = {
            copilot = function()
                return require('codecompanion.adapters').extend('copilot', {
                    schema = { model = { default = 'gpt-5-mini' } },
                })
            end,
        }
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
                    modes = { n = { 'q', '<Space>' } },
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
            -- show_settings = true,
            window = {
                layout   = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
                -- width = 1,
                -- height = 0.45,
                width    = 0.45,
                height   = 1,

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
    },
    extensions = {
        history = {
            opts = {
                keymap = 'sh',
                save_chat_keymap = 'sc',
                auto_save = false,
                picker = 'snacks',
            }
        }
    }
}

codecompanion.config = function(_, plugin_opts)
    require('codecompanion').setup(plugin_opts)

    -- INFO: auto-save chat when chat history exist
    vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanion*Finished',
        group = vim.api.nvim_create_augroup('UserCodeCompanionHistory', { clear = true }),
        callback = vim.schedule_wrap(function(opts)
            if opts.match == 'CodeCompanionRequestFinished' or opts.match == 'CodeCompanionAgentFinished' then
                if opts.match == 'CodeCompanionRequestFinished' and opts.data.strategy ~= 'chat' then
                    return
                end

                local chat_module = require('codecompanion.strategies.chat')
                local bufnr = opts.data.bufnr
                if not bufnr then return end

                local history = require('codecompanion').extensions.history

                local chat_history = history.get_chats(function(chat_data) return chat_data.cwd == vim.fn.getcwd() end)
                local chat = chat_module.buf_get_chat(bufnr)
                if chat and not vim.tbl_isempty(chat_history) then
                    history.save_chat(chat)
                end
            end
        end),
    })
end

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
