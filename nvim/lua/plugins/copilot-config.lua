local sidekick = {
    'folke/sidekick.nvim',
    event = 'VeryLazy'
}

sidekick.opts = {
    cli = {
        win = {
            wo = { winhighlight = 'Normal:Normal,NormalNC:NormalNC' },
        },
        mux = {
            backend = 'tmux',
            enabled = true,
        },
    }
}

sidekick.keys = function()
    local sidekick_keymap = require('config.keymaps').sidekick

    return {
        {
            sidekick_keymap.apply_nes,
            function()
                -- if there is a next edit, jump to it, otherwise apply it if any
                if not require('sidekick').nes_jump_or_apply() then
                    return sidekick_keymap.apply_nes
                end
            end,
            expr = true,
            desc = 'Goto/Apply Next Edit Suggestion',
        },
        {
            sidekick_keymap.toggle,
            function()
                require('sidekick.cli').toggle({ name = 'copilot', focus = true })
            end,
            desc = 'Sidekick Toggle CLI',
        },
        {
            sidekick_keymap.toggle,
            function() require('sidekick.cli').send({ msg = '{selection}' }) end,
            mode = { 'x' },
            desc = 'Sidekick Send Visual Selection',
        },
        {
            sidekick_keymap.prompt,
            function()
                require('sidekick.cli').prompt()
            end,
            mode = { 'n', 'x' },
            desc = 'Sidekick Prompt Picker',
        },
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
    interactions = {
        chat = {
            adapter = {
                name = 'copilot',
                model = 'gemini-3-flash-preview',
            },
            keymaps = {
                stop = {
                    modes = { n = '<C-c>', i = '<C-c>' },
                },
                close = {
                    modes = { n = 'Q' }
                },
                hide = {
                    modes = { n = 'q', i = '<C-q>' },
                    callback = function(chat) chat.ui:hide() end,
                    description = 'Hide chat',
                },
            },
        },
        inline = {
            adapter = {
                name = 'copilot',
                model = 'gpt-5-mini',
            },
            keymaps = {
                stop = {
                    modes = { n = '<C-c>' }
                }
            }
        },
    },
    display = {
        chat = {
            -- intro_message = '',
            -- show_settings = true,
            window = {
                title  = ' Code Companion ',
                layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
                width  = 80,
                height = 20,
                -- width    = 0.45,
                -- height   = 1,

                -- Options below only apply to floating windows
                -- relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
                -- border   = 'solid',
                -- row = vim.o.lines - (math.floor(0.45 * vim.o.lines)) - 3, -- INFO: `-3` is from -1 statusline and -2 from border top-bottom
                -- row      = 0,
                -- opts   = {
                -- col      = vim.o.columns,
                --     -- winhighlight = 'Normal:NormalFloat,NormalNC:NormalFloatNC',
                --     number = false,
                --     relativenumber = false,
                -- },
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
                chat_filter = function (chat_data)
                    return chat_data.cwd == vim.fn.getcwd()
                end,
                auto_generate_title = true,
                title_generation_opts = {
                    adapter = 'copilot',
                    model = 'gpt-5-mini',
                },
                summary = {
                    generation_opts = {
                        adapter = 'copilot',
                        model = 'gpt-5-mini',
                    },
                }
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
            -- Guard: ensure opts and opts.data exist
            if not opts or not opts.data or not opts.match then
                return
            end

            local match = opts.match
            -- Only handle request or tools finished events
            if match ~= 'CodeCompanionRequestFinished' and match ~= 'CodeCompanionToolsFinished' then
                return
            end

            -- For requests, only save if interaction was a chat
            if match == 'CodeCompanionRequestFinished' and opts.data.interaction ~= 'chat' then
                return
            end

            local bufnr = opts.data.bufnr
            if not bufnr then
                return
            end

            -- Return early if no history exists for current CWD
            local history = require('codecompanion').extensions.history
            local cwd = vim.fn.getcwd()
            local chat_history = history.get_chats(function(chat_data) return chat_data.cwd == cwd end)
            if not chat_history or next(chat_history) == nil then
                return
            end

            local chat_module = require('codecompanion.interactions.chat')
            local chat = chat_module.buf_get_chat(bufnr)
            if chat then
                history.save_chat(chat)
            end
        end),
    })
end

codecompanion.keys = function()
    local codecompanion_keymap = require('config.keymaps').codecompanion

    return {
        { codecompanion_keymap.new_chat, '<Cmd>CodeCompanionChat<CR>',        mode = { 'n' }, desc = 'CodeCompanion - New Chat' },
        { codecompanion_keymap.toggle,   '<Cmd>CodeCompanionChat Toggle<CR>', mode = { 'n' }, desc = 'CodeCompanion - Toggle Chat' },
        { codecompanion_keymap.toggle,   ':CodeCompanionChat Add<CR>',        mode = { 'v' }, desc = 'CodeCompanion - Add to Chat' },
        { codecompanion_keymap.inline,   ':CodeCompanion ',                   mode = { 'v' }, desc = 'CodeCompanion - Inline Chat' },
    }
end

return {
    sidekick,
    codecompanion,
}
