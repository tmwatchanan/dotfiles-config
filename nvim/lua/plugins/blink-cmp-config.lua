local M = {
    'saghen/blink.cmp',
    -- version = '*',
    build = 'cargo build --release',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
        'rafamadriz/friendly-snippets',
        { 'copilot.lua',           optional = true }, -- github copilot if available

        { 'windwp/nvim-autopairs', opts = { check_ts = true, fast_wrap = { map = '<C-l>' } } }
    },
    cond = not vim.g.vscode,
}

M.opts = function()
    local copilot_status, copilot_suggestion = pcall(require, 'copilot.suggestion')

    return {
        keymap = {
            -- ['<CR>'] = {
            --     function(_)
            --         if copilot_status and copilot_suggestion.is_visible() then
            --             copilot_suggestion.accept()
            --             return true -- NOTE: must return true, skip fallback case
            --         end
            --     end,
            --     'accept',
            --     'fallback',
            -- },
            ['<C-e>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.dismiss()
                        return true
                    end
                end,
                'cancel',
                'fallback',
            },
            ['<Tab>'] = {
                function(cmp)
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.accept()
                        return true -- NOTE: must return true, skip fallback case
                    end
                    -- if not cmp.is_visible() then return end
                    -- vim.schedule(function() require('blink.cmp.completion.list').select_next() end)
                    -- return true
                end,
                'accept',
                'snippet_forward',
                'fallback'
            },
            ['<S-Tab>'] = {
                function(cmp)
                    if not cmp.is_visible() then return end
                    vim.schedule(function() require('blink.cmp.completion.list').select_prev() end)
                    return true
                end,
                'snippet_backward',
                'fallback',
            },
            ['<C-h>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.prev()
                        return true
                    end
                end,
                'fallback',
            },
            ['<C-l>'] = {
                function(_)
                    if copilot_status and copilot_suggestion.is_visible() then
                        copilot_suggestion.next()
                        return true
                    end
                end,
                'fallback',
            },
            ['<M-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        },
        completion = {
            list = {
                max_items = 50,
                selection = {
                    preselect = true,
                    auto_insert = function(ctx)
                        return ctx.mode == 'cmdline' and not vim.tbl_contains({ '/', '/?' }, vim.fn.getcmdtype())
                    end
                }
            },
            menu = {
                auto_show = false,
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
            nerd_font_variant = 'mono'
        },
        cmdline = {
            keymap = {
                ['<CR>'] = { 'accept_and_enter', 'fallback' },
                ['<C-e>'] = { 'hide', 'fallback' },
                ['<Tab>'] = { 'show_and_insert', 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
            },
            completion = {
                menu = { auto_show = false },
                ghost_text = { enabled = false },
            },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
            per_filetype = {
                sql = { 'snippets', 'dadbod', 'buffer' },
            },
            providers = {
                buffer = {
                    opts = { enable_in_ex_commands = true }
                },
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
            },
        }
    }
end

return M
