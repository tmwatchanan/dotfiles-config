local M = {
    'saghen/blink.cmp',
    version = '*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
        'rafamadriz/friendly-snippets',
        'copilot.lua' -- github copilot if available
    },
}

M.opts = function()
    local copilot_status, copilot_suggestion = pcall(require, 'copilot.suggestion')
    local is_copilot_visible = copilot_status and copilot_suggestion.is_visible()

    return {
        keymap = {
            ['<CR>'] = {
                function(_)
                    if is_copilot_visible then
                        copilot_suggestion.accept()
                        return true -- NOTE: must return true, skip fallback case
                    end
                end,
                'accept',
                'fallback',
            },
            ['<C-e>'] = {
                function(_)
                    if is_copilot_visible then
                        copilot_suggestion.dismiss()
                        return true
                    end
                end,
                'hide',
                'fallback',
            },
            ['<Tab>'] = {
                function(_)
                    if is_copilot_visible then
                        copilot_suggestion.next()
                        return true
                    end
                end,
                'select_next',
                'snippet_forward',
                'fallback'
            },
            ['<S-Tab>'] = {
                function(_)
                    if is_copilot_visible then
                        copilot_suggestion.prev()
                        return true
                    end
                end,
                'select_prev',
                'snippet_backward',
                'fallback',
            },
            ['<M-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

            cmdline = {
                ['<CR>'] = {
                    function(cmp)
                        return cmp.select_and_accept({
                            callback = function()
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', true)
                            end,
                        })
                    end,
                    'fallback',
                },
                ['<C-e>'] = { 'hide', 'fallback' },
                ['<Tab>'] = { 'show', 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
            }
        },
        completion = {
            list = {
                max_items = 100,
                selection = {
                    preselect = true,
                    auto_insert = function(ctx)
                        return ctx.mode == 'cmdline' and not vim.tbl_contains({ '/', '/?' }, vim.fn.getcmdtype())
                    end
                }
            },
            menu = {
                auto_show = function(ctx)
                    return ctx.mode ~= 'cmdline'
                end,
                winblend = vim.o.pumblend,
                winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu',
                scrollbar = false,
                draw = {
                    gap = 2,
                    columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                window = {
                    winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,BlinkCmpDocSeparator:Pmenu',
                }
            },
            ghost_text = {
                enabled = false,
            }
        },
        signature = {
            enabled = true,
            window = {
                max_width = 60,
                winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,BlinkCmpDocSeparator:Pmenu',
            }
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
    }
end

return M
