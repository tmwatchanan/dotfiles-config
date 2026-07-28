local M = {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    cond = not vim.g.vscode,
}

local target_term_id = vim.v.count1

M.opts = function()
    local keymaps = require('config.keymaps').snacks
    local picker_keymap = keymaps.picker

    local upad = { '', '', '', ' ', ' ', ' ', ' ', ' ' }

    -- gitignore-style globs, so slash-free patterns match at any depth. Fed to
    -- `rg -g !<glob>` (grep) and `fd --exclude` (files), i.e. filtered at the
    -- source instead of after the fact, keeping the picker counts honest.
    local test_globs = {
        'test_*',
        '*_test.*',
        '*.test.*',
        '*.spec.*',
        'conftest.py',
        'test',
        'tests',
        '__tests__',
    }

    local gitmodules_cache = {}

    ---@return string[] submodule paths, relative to `root`
    local function submodule_paths(root)
        local file = vim.fs.joinpath(root, '.gitmodules')
        local stat = vim.uv.fs_stat(file)
        if not stat then return {} end

        local cached = gitmodules_cache[root]
        if cached and cached.mtime == stat.mtime.sec then return cached.paths end

        local paths = {}
        for _, line in ipairs(vim.fn.readfile(file)) do
            local path = line:match('^%s*path%s*=%s*(.-)%s*$')
            if path then paths[#paths + 1] = path end
        end

        gitmodules_cache[root] = { mtime = stat.mtime.sec, paths = paths }
        return paths
    end

    -- Submodules hold pinned, externally-owned code that swamps a search (~1.2k of
    -- the 1.6k files in a ranker-v2 worktree). `.gitmodules` is tracked, so reading
    -- it covers every worktree and every other repo without per-project config.
    local function submodule_globs(cwd)
        local root = vim.fs.root(cwd, '.gitmodules')
        if not root then return {} end

        local globs = {}
        for _, path in ipairs(submodule_paths(root)) do
            -- nil when the submodule sits outside cwd, where rg/fd never look anyway,
            -- and '.' when cwd *is* the submodule, which is a deliberate search of it
            local rel = vim.fs.relpath(cwd, vim.fs.joinpath(root, path))
            if rel and rel ~= '.' then globs[#globs + 1] = rel end
        end
        return globs
    end

    local exclude_groups = {
        exclude_tests = function() return test_globs end,
        exclude_submodules = submodule_globs,
    }

    -- Snacks applies `config` once per config layer, so this runs several times per
    -- picker open: rebuild from the untouched snapshot rather than appending.
    local function apply_excludes(opts)
        opts.exclude_base = opts.exclude_base or opts.exclude or {}

        local cwd = opts.cwd or vim.uv.cwd()
        local exclude = vim.list_slice(opts.exclude_base)
        for name, globs in pairs(exclude_groups) do
            if opts[name] then vim.list_extend(exclude, globs(cwd)) end
        end
        opts.exclude = exclude

        return opts
    end

    local function toggle_exclude(picker, name)
        picker.opts[name] = not picker.opts[name]
        apply_excludes(picker.opts)

        picker.list:set_target()
        picker:find()
    end

    local fullscreen_layout = {
        layout = {
            box = 'vertical',
            backdrop = false,
            width = 0.85,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            border = 'rounded',
            { win = 'input',   height = 1,   border = 'rounded', title = '{title} {live} {flags}' },
            { win = 'list',    border = upad },
            { win = 'preview', height = 0.4, border = 'rounded', title = '{preview}' },
        },
    }

    local select_layout = {
        preview = false,
        layout = {
            box = 'vertical',
            backdrop = false,
            width = 0.3,
            min_width = 40,
            height = 0.4,
            min_height = 3,
            { win = 'input', border = 'solid', height = 1, title = '{title}' },
            { win = 'list',  border = 'hpad' },
        },
    }

    return {
        image = { enabled = false },
        picker = {
            ui_select = true,
            layout = fullscreen_layout,
            sources = {
                files = { hidden = true },
                select = { layout = select_layout },
                help = { confirm = 'vsplit' },
            },
            formatters = {
                file = { filename_first = false },
                selected = { show_always = true }
            },
            icons = {
                ui = {
                    selected = '▌ ',
                    unselected = '  ',
                }
            },
            exclude_submodules = true,
            config = apply_excludes,
            -- each flag marks the state that deviates from the default, so a plain
            -- title means tests included and submodules excluded
            toggles = {
                exclude_tests = 'T',
                exclude_submodules = { icon = 'S', value = false },
            },
            actions = {
                -- snacks auto-generates `toggle_<name>` for every entry in
                -- `toggles`, but those only flip the boolean; `exclude` has to be
                -- rebuilt from the source's own excludes for the finder to see it.
                toggle_test_files = function(picker)
                    toggle_exclude(picker, 'exclude_tests')
                end,
                toggle_submodule_files = function(picker)
                    toggle_exclude(picker, 'exclude_submodules')
                end,
                send_to_qflist = function(picker)
                    picker:close()

                    local sel = picker:selected()
                    local items = #sel > 0 and sel or picker:items()

                    local qf = {} ---@type vim.quickfix.entry[]
                    for _, item in ipairs(items) do
                        qf[#qf + 1] = {
                            filename = require('snacks').picker.util.path(item),
                            bufnr = item.buf,

                            col = item.pos and item.pos[2] or 1,
                            end_lnum = item.end_pos and item.end_pos[1] or nil,
                            end_col = item.end_pos and item.end_pos[2] or nil,
                            text = item.line or item.comment or item.label or item.name or item.detail or item.text,
                            pattern = item.search,
                            valid = true,
                        }
                    end

                    vim.fn.setqflist(qf)
                    require('snacks').picker.qflist()
                end
            },
            win = {
                input = {
                    keys = {
                        [picker_keymap.action_scroll_up] = { 'preview_scroll_up', mode = { 'i', 'n' } },
                        [picker_keymap.action_scroll_down] = { 'preview_scroll_down', mode = { 'i', 'n' } },
                        [picker_keymap.action_focus_preview] = { 'focus_preview', mode = { 'i', 'n' } },
                        [picker_keymap.action_select_all] = { 'select_all', mode = { 'i', 'n' } },
                        [picker_keymap.action_send_to_qflist] = { 'send_to_qflist', mode = { 'i', 'n' } },
                        [picker_keymap.action_toggle_tests] = { 'toggle_test_files', mode = { 'i', 'n' } },
                        [picker_keymap.action_toggle_submodules] = { 'toggle_submodule_files', mode = { 'i', 'n' } },
                    }
                },
                list = {
                    keys = {
                        [picker_keymap.action_scroll_up] = 'preview_scroll_up',
                        [picker_keymap.action_scroll_down] = 'preview_scroll_down',
                        [picker_keymap.action_focus_preview] = 'focus_preview',
                        [picker_keymap.action_select_all] = 'select_all',
                        [picker_keymap.action_send_to_qflist] = 'send_to_qflist',
                        [picker_keymap.action_toggle_tests] = 'toggle_test_files',
                        [picker_keymap.action_toggle_submodules] = 'toggle_submodule_files',
                    }
                }
            }
        },
        scratch = {
            name = 'Project Notes',
            ft = 'markdown',
            icon = { '󰠮', 'SnacksScratchTitle' },
            root = vim.fn.stdpath('data') .. '/notes',
            autowrite = true,
            filekey = {
                cwd = true,
                branch = false,
                count = false,
            },
            win = {
                width = 0.8,
                height = 0.8,
                border = 'solid',
                title_pos = 'left',
                footer_pos = 'right',
                keys = {
                    ['q'] = 'close',
                },
            },
        },
        terminal = {
            win = {
                height   = 0,
                width    = 0,
                relative = 'editor',
                position = 'float',
                border   = { '', '', '', ' ', ' ', ' ', ' ', ' ' },
                wo       = {
                    winhighlight =
                    'Normal:SnacksTerminalNormal,NormalNC:SnacksTerminalNormal,FloatBorder:SnacksTerminalBorder,FloatFooter:SnacksTerminalFooter',
                },
                bo       = {
                    filetype = 'snacks_terminal',
                },
                on_buf   = function(self)
                    -- NOTE: `on_buf` called before `on_win`
                    target_term_id = vim.b[self.buf].snacks_terminal.id
                end,
                on_win   = function(self)
                    -- INFO: show footer messages
                    local footer_msg = 'Running command: '
                    if type(self.cmd) == 'table' then
                        footer_msg = footer_msg .. table.concat(self.cmd, ' ')
                    else
                        footer_msg = self.cmd and
                            (footer_msg .. self.cmd) or
                            ('Terminal ID: ' .. target_term_id)
                    end
                    vim.api.nvim_win_set_config(self.win, { footer = footer_msg })

                    -- HACK: manually delete term buffer before destroy win
                    local function cleanup_term(terminal)
                        if vim.api.nvim_buf_is_loaded(terminal.buf) then
                            vim.api.nvim_buf_delete(terminal.buf, { force = true })
                        end
                        terminal:destroy()
                        vim.cmd.checktime()
                    end

                    -- INFO: if we have cmd finished clean up after close
                    local event = self.cmd and 'WinClosed' or 'TermClose'
                    self:on(event, function()
                        cleanup_term(self)
                    end, { buf = true })
                end,
            }
        },
        bigfile = {
            enabled = true,
            size = 1.5 * 1024 * 1024, -- MB
            ---@param ctx {buf: number, ft:string}
            setup = function(ctx)
                vim.cmd([[NoMatchParen]])
                require('snacks').util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
                vim.b.minianimate_disable = true
                vim.schedule(function()
                    vim.bo[ctx.buf].syntax = ctx.ft
                end)
            end,
        },
    }
end

M.keys = function()
    local snacks = require('snacks')

    local keymaps = require('config.keymaps').snacks
    local picker_keymap = keymaps.picker
    local bufdetele_keymap = keymaps.bufdelete
    local terminal_keymap = keymaps.terminal
    local scratch_keymap = keymaps.scratch

    -- delta's active git-config feature is dark; on a light colorscheme
    -- (dayfox/dawnfox) lazygit's diff would render dark hunks on the light float.
    -- Point delta at the light `nightfox` delta feature via DELTA_FEATURES when the
    -- theme is light. Likewise lazygit's own selectedLineBgColor (#363646, dark)
    -- is invisible under the light float's dark text, so layer config.light.yml on
    -- top of the base config via LG_CONFIG_FILE (comma-separated, later wins).
    -- `nil` on dark themes leaves both the delta feature and lazygit theme untouched.
    local function lazygit_opts()
        if vim.o.background == 'light' then
            local base = vim.fn.expand('~/.config/lazygit/config.yml')
            local overlay = vim.fn.expand('~/.config/lazygit/config.light.yml')
            return {
                env = {
                    DELTA_FEATURES = 'nightfox',
                    LG_CONFIG_FILE = base .. ',' .. overlay,
                },
            }
        end
        return nil
    end

    -- yazi exits once a file is chosen, so hand it a chooser file and open the
    -- selection when the float tears down. The path is fixed (not tempname) to keep
    -- snacks' terminal id stable across toggles; truncate it first so a selection
    -- from a previous run can't be replayed.
    local yazi_chooser = vim.fs.joinpath(vim.fn.stdpath('cache'), 'yazi-chooser')
    local function yazi_toggle()
        vim.fn.writefile({}, yazi_chooser)
        local file = vim.fn.expand('%:p')
        local entry = vim.fn.filereadable(file) == 1 and file or (vim.uv.cwd() or '.')
        snacks.terminal.toggle({ 'yazi', entry, '--chooser-file', yazi_chooser }, {
            win = {
                on_close = function()
                    local chosen = vim.fn.filereadable(yazi_chooser) == 1 and vim.fn.readfile(yazi_chooser) or {}
                    vim.fn.writefile({}, yazi_chooser)
                    vim.schedule(function()
                        for _, path in ipairs(chosen) do
                            if path ~= '' then vim.cmd.edit(vim.fn.fnameescape(path)) end
                        end
                    end)
                end,
            },
        })
    end

    -- INFO: only mapped toggle key for no cmd terminal
    local terminal_toggle_opts = {
        win = {
            keys = {
                [terminal_keymap.toggle] = { 'toggle', mode = 't' }
            },
        }
    }

    return {
        { picker_keymap.resume,           function() snacks.picker.resume() end },
        { picker_keymap.buffers,          function() snacks.picker.buffers() end },
        { picker_keymap.jumplist,         function() snacks.picker.jumps() end },
        { picker_keymap.help_tags,        function() snacks.picker.help() end },
        { picker_keymap.find_files,       function() snacks.picker.files({ hidden = true }) end },
        { picker_keymap.oldfiles,         function() snacks.picker.recent() end },
        { picker_keymap.search_workspace, function() snacks.picker.grep({ hidden = true }) end },
        { picker_keymap.search_buffers,   function() snacks.picker.grep_buffers({ hidden = true }) end },
        { picker_keymap.grep_workspace,   function() snacks.picker.grep_word({ hidden = true }) end,   mode = { 'n', 'x' } },
        { picker_keymap.keymaps,          function() snacks.picker.keymaps() end },

        { bufdetele_keymap.delete,        function() snacks.bufdelete.delete() end },

        {
            scratch_keymap.toggle,
            function()
                snacks.scratch.open({
                    win = {
                        title = ' Project Notes - ' .. (vim.uv.cwd() or '') .. ' ',
                        on_win = function(self)
                            local fname = vim.api.nvim_buf_get_name(self.buf)
                            local stat = fname ~= '' and vim.uv.fs_stat(fname)
                            local footer = stat
                                and (' Updated: ' .. os.date('%d-%b-%Y %H:%M', stat.mtime.sec) .. ' ')
                                or ''
                            vim.api.nvim_win_set_config(self.win, { footer = footer })
                        end,
                    }
                })
            end
        },

        {
            terminal_keymap.toggle,
            function()
                -- NOTE: check target_term_id exist in terminal list
                local user_input      = vim.v.count ~= 0
                local check_term_id   = user_input and vim.v.count1 or target_term_id
                local terminals       = snacks.terminal.list()
                local matched         = false
                local last_checked_id = nil

                for _, terminal in ipairs(terminals) do
                    local term_id = vim.b[terminal.buf].snacks_terminal.id
                    if term_id then
                        if term_id == check_term_id then
                            matched = true
                            break
                        end
                        if not last_checked_id or (last_checked_id < check_term_id and term_id < check_term_id) then
                            last_checked_id = term_id
                        end
                    end
                end

                -- INFO: resolve final terminal id, fallback to prev id before target id in list
                local final_id = check_term_id
                if last_checked_id and not matched and not user_input then
                    final_id = last_checked_id
                end

                snacks.terminal.toggle(nil, vim.tbl_deep_extend('force', terminal_toggle_opts, {
                    count = final_id
                }))
            end
        },
        { terminal_keymap.lazygit,              function() snacks.terminal.toggle({ 'lazygit' }, lazygit_opts()) end },
        { terminal_keymap.lazygit_file_history, function() snacks.terminal.toggle({ 'lazygit', '-f', vim.fn.expand('%') }, lazygit_opts()) end },
        { terminal_keymap.yazi,                 yazi_toggle },

        { keymaps.gitbrowse,                    function() snacks.gitbrowse() end,                                    desc = 'Snacks: Git Browse',    mode = { 'n', 'v' } },
        { keymaps.git_blame_line,               function() snacks.git.blame_line() end,                               desc = 'Snacks: Git Blame Line' },
    }
end

return M
