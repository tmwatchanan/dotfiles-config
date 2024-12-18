local M = {
    'saghen/blink.cmp',
    version = 'v0.*',
    lazy = false, -- internally lazy loaded
    dependencies = {
        { 'rafamadriz/friendly-snippets' },

        {
            'copilot.lua',
            optional = true,
        }, -- github copilot if available
    },
    cond = not vim.g.vscode,
}

M.opts = function()
    local copilot_status, copilot_suggestion = pcall(require, 'copilot.suggestion')
    local is_copilot_available = copilot_status and copilot_suggestion.is_visible()

    return {
        keymap = {
            ['<CR>'] = {
                function(_)
                    if is_copilot_available then
                        copilot_suggestion.accept()
                        return true -- NOTE: must return true, skip fallback case
                    end
                end,
                'accept',
                'fallback',
            },
            ['<C-e>'] = {
                function(_)
                    if is_copilot_available then
                        copilot_suggestion.dismiss()
                        return true
                    end
                end,
                'hide',
                'fallback',
            },
            ['<Tab>'] = {
                function(_)
                    if is_copilot_available then
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
                    if is_copilot_available then
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
                    if is_copilot_available then
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
                    if is_copilot_available then
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
        completion = {
            list = {
                max_items = 100,
                selection = 'preselect',
            },
            menu = {
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
                    max_width = 80,
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
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
            -- TODO: cmdline cmp still not working..
            cmdline = function()
                local type = vim.fn.getcmdtype()
                -- Search forward and backward
                if type == '/' or type == '?' then return { 'buffer' } end
                -- Commands
                if type == ':' then return { 'cmdline' } end
                return {}
            end,
            providers = {
                -- dont show LuaLS require statements when lazydev has items
                lsp = { fallback_for = { 'lazydev' } },
                lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
            },
        }
    }
end

return M
