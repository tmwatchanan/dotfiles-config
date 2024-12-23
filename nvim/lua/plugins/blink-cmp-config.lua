local M = {
    'saghen/blink.cmp',
    version = '*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
        'rafamadriz/friendly-snippets',
        { 'copilot.lua', optional = true }, -- github copilot if available
    },
    cond = not vim.g.vscode,
}

M.opts = function()
    local copilot_status, copilot_suggestion = pcall(require, 'copilot.suggestion')
    local is_copilot_available = copilot_status and copilot_suggestion.is_visible()

    -- INFO: override list.selection to manual for cmdline
    local list = require 'blink.cmp.completion.list'
    local orig_list_selection = list.config.selection
    vim.api.nvim_create_autocmd('CmdlineEnter', {
        callback = function()
            list.config.selection = 'manual'
        end,
    })
    vim.api.nvim_create_autocmd('CmdlineLeave', {
        callback = function()
            list.config.selection = orig_list_selection
        end,
    })

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
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
            }
        },
        completion = {
            list = {
                max_items = 100,
                selection = 'preselect',
            },
            menu = {
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
            -- INFO: only enable cmp for cmdline not with search
            cmdline = function()
                local type = vim.fn.getcmdtype()
                if type == ':' then return { 'cmdline' } end
                -- if type == '/' or type == '?' then return { 'buffer' } end
                return {}
            end,
            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        }
    }
end

return M
