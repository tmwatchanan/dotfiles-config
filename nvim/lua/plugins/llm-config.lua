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

-- INFO: ensure a cwd-local session exists for `name`. Sidekick's cli.toggle/show/send
-- use State.with(attach=true) which falls through to a disambiguation picker when
-- multiple sessions share the same tool name across cwds. filter.cwd=true scopes it
-- but rejects synthetic states (a fresh slot gives "No tools match"). State.attach
-- with our tool config creates the cwd-local session AND opens the float window
-- (terminal:start always calls open_win) — so we return `true` and the caller skips
-- the subsequent cli.toggle/show, which would otherwise close the just-opened float.
local function ensure_cwd_session(name)
    local State = require('sidekick.cli.state')
    local cwd   = vim.fn.getcwd()
    for _, s in ipairs(State.get({ name = name })) do
        if s.session and s.session.cwd == cwd then return false end
    end
    State.attach({ tool = require('sidekick.config').get_tool(name) }, { show = true, focus = true })
    return true
end

-- INFO: scoped CLI picker — bypasses sidekick.cli.select so we can:
--   1. Drop dead clones from the registry (killed CLI leaves a ghost otherwise).
--   2. Hide bases whose cwd-local clones already exist (picking them would route
--      back through resolve_slot to the same live clone).
--   3. Filter the picker list to current-cwd sessions plus non-clone bases.
--   4. Trim the 40-col cwd-column padding from sidekick's row formatter, since
--      every visible item is now in the current cwd and the column overflows the
--      picker viewport.
local function open_picker(cb)
    local tools = require('sidekick.config').cli.tools
    local State = require('sidekick.cli.state')
    local UI    = require('sidekick.cli.ui.select')
    local cwd   = vim.fn.getcwd()

    -- live (any cwd) drives the prune; has_clone (cwd-local) drives the base hide.
    local live, has_clone = {}, {}
    for _, s in ipairs(State.get({ attached = true })) do
        live[s.tool.name] = true
        if s.session and s.session.cwd == cwd then
            local base = s.tool.name:match('^(.-)_%d+$')
            if base then has_clone[base] = true end
        end
    end

    local hidden = {}
    for name, cfg in pairs(tools) do
        local is_clone = name:match('_%d+$') ~= nil
        if is_clone and not live[name] then
            tools[name] = nil
        elseif not is_clone and has_clone[name] then
            hidden[name], tools[name] = cfg, nil
        end
    end

    -- Real sessions in this cwd, plus base entries (synthetic states without a
    -- session). Drop clone synthetics from other cwds and clone entries pointing
    -- at sessions running elsewhere.
    local items = vim.tbl_filter(function(t)
        if t.session then return t.session.cwd == cwd end
        return t.tool.name:match('_%d+$') == nil
    end, State.get({ installed = true }))

    local function restore()
        for name, cfg in pairs(hidden) do tools[name] = cfg end
    end

    if #items == 0 then
        restore()
        return cb(nil)
    end

    -- Reuse sidekick's per-row formatter but collapse the 40-col cwd pad to a
    -- single double-space separator so the cwd column still renders without
    -- pushing past the picker viewport.
    local function format_compact(item, picker)
        local parts, result = UI.format(item, picker), {}
        for _, p in ipairs(parts) do
            local text = p[1] or ''
            if text:match('^ +$') and #text > 10 then
                result[#result + 1] = { '  ' }
            else
                result[#result + 1] = p
            end
        end
        return result
    end

    vim.ui.select(items, {
        prompt      = 'Select CLI tool:',
        kind        = 'sidekick_cli',
        format_item = function(item)
            return table.concat(vim.tbl_map(function(p) return p[1] end, format_compact(item)))
        end,
        snacks      = { format = format_compact },
    }, function(state)
        restore()
        if state and not state.installed then
            UI.on_missing(state.tool)
            state = nil
        end
        cb(state)
    end)
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
            -- before calling this. Footer renders the slot as a 5-segment sentence:
            -- "Sidekick ID: <id> with <cli> on <cwd>" — each variable part carries its
            -- own bold hl (id, cli name, cwd path) and the " with "/" on " connectors
            -- use Normal. bold() resolves the base group's attrs and re-sets with
            -- bold; idempotent + theme-aware (re-runs on each float open).
            config = function(self)
                local function bold(name, base)
                    local hl = vim.api.nvim_get_hl(0, { name = base, link = false }) or {}
                    hl.bold = true
                    vim.api.nvim_set_hl(0, name, hl)
                end
                bold('SidekickFooterAccent', 'SnacksTerminalFooter')
                bold('SidekickFooterCli',    'MarkSignNumHL')
                bold('SidekickFooterPath',   'WarningMsg')

                local base, id = self.tool.name:match('^(.-)_(%d+)$')
                local cwd      = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
                self.opts.float.footer = {
                    { 'Sidekick ID: ' .. id, 'SidekickFooterAccent' },
                    { ' with ',              'Normal' },
                    { base,                  'SidekickFooterCli' },
                    { ' on ',                'Normal' },
                    { cwd,                   'SidekickFooterPath' },
                }
                self.opts.float.footer_pos = 'left'
            end,
            -- INFO: buffer-local terminal-mode keymap registered on each sidekick float
            -- so <leader>s from inside the CLI hides the float (snacks-terminal pattern).
            -- The rhs 'toggle' resolves to the terminal's M:toggle method.
            keys = {
                shift_enter = { '<S-CR>', function(self)
                    vim.api.nvim_chan_send(self.job, '\x1b[13;2u')
                end },
                toggle = { '<leader>s', 'toggle' },
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
                    OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = 'true',
                    OPENCODE_EXPERIMENTAL_LSP_TOOL = 'true',
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
                open_picker(function(state)
                    if not state then return end
                    local base, id = state.tool.name:match('^(.-)_(%d+)$')
                    local name
                    if base then
                        target_base, target_cli_id = base, tonumber(id)
                        name = state.tool.name
                    else
                        local slot  = resolve_slot(state.tool.name, target_cli_id)
                        local clone = ensure_clone(state.tool.name, slot)
                        if not clone then return end
                        target_base, target_cli_id = state.tool.name, slot
                        name = clone
                    end
                    if ensure_cwd_session(name) then return end
                    require('sidekick.cli').show({ name = name, filter = { cwd = true }, focus = true })
                end)
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
                    if ensure_cwd_session(clone) then return end
                    require('sidekick.cli').toggle({ name = clone, filter = { cwd = true } })
                end

                if target_base then return go(target_base) end

                open_picker(function(state)
                    if not state then return end
                    local base, id = state.tool.name:match('^(.-)_(%d+)$')
                    if base then
                        target_base, target_cli_id = base, tonumber(id)
                        if ensure_cwd_session(state.tool.name) then return end
                        require('sidekick.cli').toggle({ name = state.tool.name, filter = { cwd = true } })
                    else
                        go(state.tool.name)
                    end
                end)
            end,
            desc = 'Sidekick Toggle (count = slot)',
        },
        {
            sidekick_keymap.toggle,
            function()
                local name = target_base and (target_base .. '_' .. target_cli_id) or nil
                if name then ensure_cwd_session(name) end
                require('sidekick.cli').send({
                    msg    = '{selection}',
                    name   = name,
                    filter = { cwd = true },
                })
            end,
            mode = { 'x' },
            desc = 'Sidekick Send Visual Selection',
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
