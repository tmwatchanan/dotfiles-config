local M = {
    'saghen/blink.cmp',
    version = '*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
        'rafamadriz/friendly-snippets',
        { 'copilot.lua', optional = true }, -- github copilot if available

        { 'windwp/nvim-autopairs', opts = { check_ts = true, fast_wrap = { map = '<C-e>' } } }
    },
    cond = not vim.g.vscode,
}

M.opts = function()
    local copilot_status, copilot_suggestion = pcall(require, 'copilot.suggestion')

    return {
        keymap = {
            ['<CR>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.accept()
                        return true -- NOTE: must return true, skip fallback case
                    end
                end,
                'accept',
                'fallback',
            },
            ['<C-e>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.dismiss()
                        return true
                    end
                end,
                'hide',
                'fallback',
            },
            ['<Tab>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
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
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.prev()
                        return true
                    end
                end,
                'select_prev',
                'snippet_backward',
                'fallback',
            },
            ['<C-j>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.next()
                        return true
                    end
                end,
                'select_next',
                'snippet_forward',
                'fallback'
            },
            ['<C-k>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
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
        },
        cmdline = {
            keymap = {
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
                ['<Tab>'] = { 'show_and_insert', 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<C-j>'] = { 'show_and_insert', 'select_next', 'fallback' },
                ['<C-k>'] = { 'select_prev', 'fallback' },
            },
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
                winblend = vim.opt.pumblend:get(),
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
                enabled = true,
            }
        },
        signature = {
            enabled = false,
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },
    }
end

return M
