local sidekick = {
    'folke/sidekick.nvim',
    event = 'VeryLazy'
}

sidekick.opts = {
    cli = {
        win = {
            wo = { winhighlight = 'Normal:Normal,NormalNC:NormalNC' }
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
                if require('sidekick').nes_jump_or_apply() then
                    return -- jumped or applied
                end
                -- fall back to normal keymap
                return sidekick_keymap.apply_nes
            end,
            expr = true,
            desc = 'Goto/Apply Next Edit Suggestion',
            mode = { 'n' },
        },
        {
            sidekick_keymap.toggle,
            function()
                require('sidekick.cli').toggle({ name = 'copilot', focus = true })
            end,
            desc = 'Sidekick Toggle CLI',
            mode = { 'n' },
        },
        {
            sidekick_keymap.toggle,
            function() require('sidekick.cli').send({ selection = true }) end,
            mode = { 'v' },
            desc = 'Sidekick Send Visual Selection',
        },
        {
            sidekick_keymap.prompt,
            function()
                require('sidekick.cli').select_prompt()
            end,
            desc = 'Sidekick Prompt Picker',
            mode = { 'n', 'v' },
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
                    modes = { n = 'q', i = '<C-q>' },
                    callback = function()
                        require('codecompanion').toggle()
                    end,
                },
            },
        },
        inline = { adapter = 'copilot' },
    },
    display = {
        chat = {
            -- intro_message = '',
            -- show_settings = true,
            window = {
                layout = 'vertical',   -- 'vertical', 'horizontal', 'float', 'replace'
                width  = 80,
                height = 20,
                -- width    = 0.45,
                -- height   = 1,

                -- Options below only apply to floating windows
                -- relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
                -- border   = 'solid',
                -- row = vim.o.lines - (math.floor(0.45 * vim.o.lines)) - 3, -- INFO: `-3` is from -1 statusline and -2 from border top-bottom
                -- row      = 0,
                -- col      = vim.o.columns,
                title  = ' Code Companion ',
                -- opts     = {
                --     winhighlight = 'Normal:NormalFloat,NormalNC:NormalFloatNC',
                -- }
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
