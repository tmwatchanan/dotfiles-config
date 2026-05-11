local sidekick      = {
    'folke/sidekick.nvim',
    event = 'VeryLazy'
}

-- INFO: numbered clones (claude_1, claude_2, ...) for multi-session per cwd.
-- Workaround from https://github.com/folke/sidekick.nvim/discussions/208 — sidekick
-- keys tmux sessions by `cmd[1]` + `is_proc`, so distinct clone names produce distinct
-- sessions even when cwd matches. Clones are registered lazily on first toggle.

-- INFO: toggleterm-style state, mirrors snacks-config.lua's `target_term_id` pattern
local target_base   = nil
local target_cli_id = 1

-- INFO: register a `<base>_<i>` clone on-demand. Symlink lives next to the real binary
-- (already on $PATH); tool entry is injected into sidekick's live config registry.
local function ensure_clone(base, i)
    local clone  = base .. '_' .. i
    local tools  = require('sidekick.config').cli.tools
    if tools[clone] then return clone end

    local exe = vim.fn.exepath(base)
    if exe == '' then return nil end

    local link = vim.fs.joinpath(vim.fs.dirname(exe), clone)
    if not vim.uv.fs_stat(link) then
        vim.uv.fs_symlink(exe, link)
    end

    local cfg    = vim.deepcopy(tools[base] or {})
    cfg.cmd      = { clone }
    cfg.is_proc  = '\\<' .. clone .. '\\>'
    tools[clone] = cfg
    return clone
end

-- INFO: if target slot is live use it; else highest live slot below target; else target.
local function resolve_slot(base, target)
    local State = require('sidekick.cli.state')
    local live  = {}
    for _, s in ipairs(State.get({ attached = true, cwd = true })) do
        local b, i = s.tool.name:match('^(.-)_(%d+)$')
        if b == base then live[tonumber(i)] = true end
    end
    if live[target] then return target end
    local best
    for i in pairs(live) do
        if i < target and (not best or i > best) then best = i end
    end
    return best or target
end

sidekick.opts = {
    cli = {
        win = {
            layout = 'float',
            float = {
                height = 1,
                width  = 1,
                -- INFO: bottom-only "invisible border" reserves a row for the footer.
                -- 8-elem order: top-left, top, top-right, right, bottom-right, bottom,
                -- bottom-left, left. Only the bottom row carries spaces.
                border = { '', '', '', '', ' ', ' ', ' ', '' },
            },
            -- INFO: per-terminal init hook; sidekick deep-copies cli.win into self.opts
            -- before calling this, so mutations to self.opts.float take effect when the
            -- window opens. Render `claude_3` as `Sidekick: claude 3` for the footer.
            config = function(self)
                local base, id = self.tool.name:match('^(.-)_(%d+)$')
                local label    = base and (base .. ' ' .. id) or self.tool.name
                self.opts.float.footer = 'Sidekick: ' .. label
            end,
            keys = {
                shift_enter = { '<S-CR>', function(self)
                    vim.api.nvim_chan_send(self.job, '\x1b[13;2u')
                end },
            },
            -- INFO: mirror snacks-terminal styling. winblend = 0 overrides the global
            -- default (options.lua sets 5 for slightly-transparent floats), same opt-out
            -- pattern as noice-config.lua's chat sub-views.
            wo = {
                winblend     = 0,
                winhighlight = 'Normal:SnacksTerminalNormal,NormalNC:SnacksTerminalNormal,FloatBorder:SnacksTerminalBorder,FloatFooter:SnacksTerminalFooter',
            },
            -- split = { width = 0.45 },
        },
        tools = {
            claude = {
                env = (function()
                    local env = {}

                    if vim.fn.getcwd():find('gogoboard') then
                        env.PATH = vim.fn.expand('~/Developer/toolchains/esp-clangd/bin')
                            .. ':' .. vim.uv.os_environ().PATH
                    end

                    return env
                end)(),
            },
            opencode = {
                env = {
                    OPENCODE_EXPERIMENTAL_LSP_TOOL = 'true',
                    OPENCODE_THEME = 'system'
                },
            },
            ocv = {
                cmd = { 'ocv' },
                env = {
                    OPENCODE_EXPERIMENTAL_LSP_TOOL = 'true',
                    OPENCODE_THEME = 'system'
                },
                keys = {
                    prompt = { '<a-p>', 'prompt' },
                },
                native_scroll = true,
                is_proc = '\\<ocv\\>',
                continue = { '--continue' },
            },
        },
        mux = {
            enabled = true,
            backend = 'tmux',
        },
    }
}

sidekick.keys = function()
    local sidekick_keymap = require('config.keymaps').sidekick

    return {
        {
            sidekick_keymap.apply_nes,
            function()
                if not require('sidekick').nes_jump_or_apply() then
                    return sidekick_keymap.apply_nes
                end
            end,
            expr = true,
            desc = 'Goto/Apply Next Edit Suggestion',
        },
        {
            sidekick_keymap.select,
            function()
                require('sidekick.cli').select({
                    filter = { installed = true },
                    cb     = function(state)
                        if not state then return end
                        local base, id = state.tool.name:match('^(.-)_(%d+)$')
                        if base then
                            target_base, target_cli_id = base, tonumber(id)
                            require('sidekick.cli').show({ name = state.tool.name, focus = true })
                        else
                            local slot  = resolve_slot(state.tool.name, target_cli_id)
                            local clone = ensure_clone(state.tool.name, slot)
                            if not clone then return end
                            target_base, target_cli_id = state.tool.name, slot
                            require('sidekick.cli').show({ name = clone, focus = true })
                        end
                    end,
                })
            end,
            desc = 'Sidekick Select CLI',
        },
        {
            sidekick_keymap.toggle,
            function()
                local count = vim.v.count

                local function go(base)
                    local id    = count > 0 and count or resolve_slot(base, target_cli_id)
                    local clone = ensure_clone(base, id)
                    if not clone then return end
                    target_base, target_cli_id = base, id
                    require('sidekick.cli').toggle({ name = clone })
                end

                if target_base then return go(target_base) end

                require('sidekick.cli').select({
                    filter = { installed = true },
                    cb     = function(state)
                        if not state then return end
                        local base, id = state.tool.name:match('^(.-)_(%d+)$')
                        if base then
                            target_base, target_cli_id = base, tonumber(id)
                            require('sidekick.cli').toggle({ name = state.tool.name })
                        else
                            go(state.tool.name)
                        end
                    end,
                })
            end,
            desc = 'Sidekick Toggle (count = slot)',
        },
        {
            sidekick_keymap.toggle,
            function()
                require('sidekick.cli').send({
                    msg  = '{selection}',
                    name = target_base and (target_base .. '_' .. target_cli_id) or nil,
                })
            end,
            mode = { 'x' },
            desc = 'Sidekick Send Visual Selection',
        },
        {
            sidekick_keymap.toggle,
            function() require('sidekick.cli').focus({ filter = { installed = true } }) end,
            mode = { 't', 'i' },
            desc = 'Sidekick Focus',
        },
    }
end

local codecompanion = {
    'olimorris/codecompanion.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'neovim-treesitter/nvim-treesitter',
        'ravitemer/codecompanion-history.nvim',
    },
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
}

codecompanion.opts = {
    interactions = {
        chat = {
            adapter = {
                name = 'copilot',
                model = 'gpt-5.4-mini',
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
                -- width  = 80,
                height = 20,
                width  = 0.4,
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
                chat_filter = function(chat_data)
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
