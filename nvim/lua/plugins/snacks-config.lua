local M = {
    'folke/snacks.nvim',
    lazy = false
}

local terminal_ids = {}
local prev_term_id = vim.v.count1
local term_created = false

M.opts = function()
    local float_border = require('config').defaults.float_border

    local keymaps = require('config.keymaps').snacks
    local picker_keymap = keymaps.picker

    local horizontal_layout = {
        layout = {
            box = 'horizontal',
            backdrop = false,
            width = 0.85,
            height = 0.8,
            border = 'none',
            {
                box = 'vertical',
                { win = 'input', height = 1,     border = float_border, title = '{source} {live} {flags}', title_pos = 'center' },
                { win = 'list',  border = 'hpad' },
            },
            {
                win = 'preview',
                title = '{preview:Preview}',
                width = 0.55,
                border = float_border,
                title_pos = 'center',
            },
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

    return {
        picker = {
            layout = horizontal_layout,
            sources = {
                diagnostics = { layout = bottom_layout },
                lsp_definitions = { layout = bottom_layout },
                lsp_declarations = { layout = bottom_layout },
                lsp_implementations = { layout = bottom_layout },
                lsp_references = { layout = bottom_layout },
                lsp_symbols = { layout = bottom_layout },
                -- grep = { layout = 'vscode' },
                -- grep_buffers = { layout = 'vscode' },
            },
            formatters = {
                file = { filename_first = true },
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
                border   = float_border,
                wo       = {
                    winhighlight =
                    'Normal:SnacksTerminalNormal,NormalNC:SnacksTerminalNormal,FloatBorder:SnacksTerminalBorder,FloatFooter:SnacksTerminalFooter',
                },
                bo       = {
                    filetype = 'snacks_terminal',
                },
                on_buf   = function(self)
                    -- NOTE: `on_buf` called before `on_win`
                    prev_term_id = vim.b[self.buf].snacks_terminal.id
                end,
                on_win   = function(self)
                    -- INFO: show footer messages
                    local footer_msg = self.cmd and
                        ('Running command: ' .. self.cmd) or
                        ('Terminal ID: ' .. prev_term_id)
                    vim.api.nvim_win_set_config(self.win, { footer = footer_msg })

                    -- INFO: assign event for TermClose
                    if not term_created then return end
                    -- vim.print('-- assign termclose event: ' .. prev_term_id)
                    term_created = false

                    vim.api.nvim_create_autocmd('TermClose', {
                        once = true,
                        buffer = self.buf,
                        callback = function()
                            local term_id = vim.b[self.buf].snacks_terminal.id
                            local term_exist = vim.tbl_contains(terminal_ids, term_id)
                            -- vim.print('term close [' .. term_id .. ']: ' .. tostring(term_exist))
                            if not term_exist then return end

                            -- HACK: manually detele term buffer before destroy win
                            if vim.api.nvim_buf_is_loaded(self.buf) then
                                vim.api.nvim_buf_delete(self.buf, { force = true })
                            end
                            self:destroy()
                            vim.cmd.checktime()

                            -- INFO: remove term from handle list and update next toggle id
                            for i = #terminal_ids, 1, -1 do
                                if terminal_ids[i] == term_id then
                                    table.remove(terminal_ids, i)
                                    prev_term_id = terminal_ids[i - 1] or terminal_ids[i] or vim.v.count1
                                    -- vim.print('removed term:', terminal_ids)
                                    break
                                end
                            end
                        end,
                    })
                end,
            }
        }
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
        { picker_keymap.find_files,       function() snacks.picker.files() end },
        { picker_keymap.oldfiles,         function() snacks.picker.recent() end },
        { picker_keymap.search_workspace, function() snacks.picker.grep() end },
        { picker_keymap.search_buffers,   function() snacks.picker.grep_buffers() end },
        { picker_keymap.grep_workspace,   function() snacks.picker.grep_word() end,   mode = { 'n', 'x' } },

        { bufdetele_keymap.delete,        function() snacks.bufdelete.delete() end },

        {
            terminal_keymap.toggle,
            function()
                -- NOTE: check prev_term_id exist in terminal_ids
                local check_term_id = vim.v.count == 0 and prev_term_id or vim.v.count1
                local term_exist = vim.tbl_contains(terminal_ids, check_term_id)
                -- vim.print('term[' .. check_term_id .. '] exist: ' .. tostring(term_exist))

                if term_exist then
                    if vim.v.count == 0 then
                        vim.api.nvim_feedkeys(tostring(prev_term_id), 'nx', false)
                    end
                else
                    -- INFO: update current term to list
                    terminal_ids[#terminal_ids + 1] = vim.v.count1
                    -- vim.print('add term:', terminal_ids)
                    term_created = true
                end
                snacks.terminal.toggle(nil, terminal_toggle_opts)
            end
        },
        { terminal_keymap.lazygit,              function() snacks.terminal.toggle('lazygit') end },
        { terminal_keymap.lazygit_file_history, function() snacks.terminal.toggle('lazygit -f ' .. vim.fn.expand('%')) end }
    }
end

return M
