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

    local horizontal_layout = {
        layout = {
            box = 'horizontal',
            backdrop = false,
            width = 0.85,
            height = 0.8,
            border = 'none',
            {
                box = 'vertical',
                { win = 'input', height = 1,     border = 'solid', title = '{source} {live} {flags}', title_pos = 'center' },
                { win = 'list',  border = 'hpad' },
            },
            {
                win = 'preview',
                title = '{preview:Preview}',
                width = 0.55,
                border = 'solid',
                title_pos = 'center',
            },
        },
    }

    local vertical_layout = {
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

    local bottom_layout = {
        layout = {
            box = 'horizontal',
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.3,
            border = 'none',
            {
                box = 'vertical',
                { win = 'input', border = 'vpad', height = 1, title = ' {title} {live} {flags}', title_pos = 'left' },
                { win = 'list',  border = 'hpad' },
            },
            { win = 'preview', title = '{preview}', width = 0.55, border = 'hpad' },
        }
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
            border = 'vpad',
            title = '{title}',
            title_pos = 'center',
            { win = 'input', height = 1,     border = 'bottom' },
            { win = 'list',  border = 'none' },
        },
    }

    return {
        picker = {
            ui_select = true,
            -- layout = horizontal_layout,
            sources = {
                diagnostics = { layout = bottom_layout },
                lsp_definitions = { layout = bottom_layout },
                lsp_declarations = { layout = bottom_layout },
                lsp_implementations = { layout = bottom_layout },
                lsp_references = { layout = bottom_layout },
                lsp_symbols = { layout = bottom_layout },
                select = { layout = select_layout },
                grep = { layout = vertical_layout },
                grep_buffers = { layout = vertical_layout },
                help = { confirm = 'vsplit'  },
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
            actions = {
                send_to_qflist = function(picker)
                    picker:close()

                    local sel = picker:selected()
                    local items = #sel > 0 and sel or picker:items()

                    local qf = {} ---@type vim.quickfix.entry[]
                    for _, item in ipairs(items) do
                        qf[#qf + 1] = {
                            filename = require('snacks').picker.util.path(item),
                            bufnr = item.buf,
                            lnum = item.pos and item.pos[1] or 1,
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
                    }
                },
                list = {
                    keys = {
                        [picker_keymap.action_scroll_up] = 'preview_scroll_up',
                        [picker_keymap.action_scroll_down] = 'preview_scroll_down',
                        [picker_keymap.action_focus_preview] = 'focus_preview',
                        [picker_keymap.action_select_all] = 'select_all',
                        [picker_keymap.action_send_to_qflist] = 'send_to_qflist',
                    }
                }
            }
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
        gitbrowse = {
            url_patterns = {
                ['git.wndv.co'] = {
                    branch = '/-/tree/{branch}',
                    file = '/-/blob/{branch}/{file}#L{line_start}-L{line_end}',
                    commit = '/-/commit/{commit}',
                },
            },
        },
    }
end

M.keys = function()
    local snacks = require('snacks')

    local keymaps = require('config.keymaps').snacks
    local picker_keymap = keymaps.picker
    local bufdetele_keymap = keymaps.bufdelete
    local terminal_keymap = keymaps.terminal

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
                            vim.api.nvim_feedkeys(tostring(check_term_id), 'nx', false)
                            matched = true
                            break
                        end
                        if not last_checked_id or (last_checked_id < check_term_id and term_id < check_term_id) then
                            last_checked_id = term_id
                        end
                    end
                end

                -- INFO: if not match any and has valid term then use the prev id before target id in list
                if last_checked_id and not matched and not user_input then
                    vim.api.nvim_feedkeys(tostring(last_checked_id), 'nx', false)
                end

                snacks.terminal.toggle(nil, terminal_toggle_opts)
            end
        },
        { terminal_keymap.lazygit,              function() snacks.terminal.toggle('lg') end },
        { terminal_keymap.lazygit_file_history, function() snacks.terminal.toggle('lg -f ' .. vim.fn.expand('%')) end },

        { keymaps.gitbrowse,                    function() snacks.gitbrowse() end,                                    desc = 'Snacks: Git Browse',    mode = { 'n', 'v' } },
        { keymaps.git_blame_line,               function() snacks.git.blame_line() end,                               desc = 'Snacks: Git Blame Line' },
    }
end

return M
