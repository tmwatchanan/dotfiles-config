local telescope_keymap = require('config.keymaps').telescope

local M = {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
        'natecraddock/telescope-zf-native.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
    },
}

M.opts = function()
    local defaults = require('config').defaults
    local telescope_actions = require('telescope.actions')

    local vertical_layout_config = {
        layout_strategy = 'vertical',
        layout_config = {
            preview_height = 0.5,
            prompt_position = 'bottom',
            width = 0.85,
            height = 0.8,
            preview_cutoff = 0,
        },
        sorting_strategy = 'ascending',
        mappings = {
            i = { ["<C-f>"] = telescope_actions.to_fuzzy_refine },
        },
    }

    local horizontal_layout_config = {
        layout_strategy = 'horizontal',
        layout_config = {
            preview_width = 0.55,
            prompt_position = 'top',
            width = 0.85,
            height = 0.8,
        },
        sorting_strategy = 'ascending',
    }

    local bottom_layout_config = {
        prompt_title = false,
        layout_strategy = 'bottom_pane',
        layout_config = {
            height = 0.3,
            preview_width = 0.4,
            prompt_position = 'bottom'
        }
    }

    local function mergeConfig(conf1, conf2)
        return vim.tbl_deep_extend('force', conf1, conf2)
    end

    local mappings_action = {
        send_to_qflist = function(bufnr)
            telescope_actions.smart_add_to_qflist(bufnr)
            vim.cmd('Telescope quickfix')
        end,

        select_all = function(bufnr)
            telescope_actions.select_all(bufnr)
        end,

        focus_preview = function(prompt_bufnr)
            local action_state = require('telescope.actions.state')
            local picker = action_state.get_current_picker(prompt_bufnr)
            local prompt_win = picker.prompt_win
            local previewer = picker.previewer
            local winid = previewer.state.winid
            local bufnr = previewer.state.bufnr
            vim.keymap.set('n', '<esc>', function()
                vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', prompt_win))
            end, { buffer = bufnr })
            vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', winid))
        end
    }

    return {
        defaults = {
            prompt_prefix = '   ',
            entry_prefix = '   ',
            selection_caret = '▌  ',
            multi_icon = '▌  ',
            results_title = false,
            color_devicons = true,
            path_display = { 'tail', 'smart' },
            set_env = { ['COLORTERM'] = 'truecolor' },
            file_ignore_patterns = { 'node_modules', '%.ipynb', '%.csv' },
            dynamic_preview_title = true,
            borderchars = defaults.float_border,
            mappings = {
                n = {
                    [telescope_keymap.action_send_to_qflist] = mappings_action.send_to_qflist,
                    [telescope_keymap.action_select_all] = mappings_action.select_all,
                    [telescope_keymap.action_focus_preview] = mappings_action.focus_preview,
                },
                i = {
                    ['<C-k>'] = telescope_actions.move_selection_previous,
                    ['<C-j>'] = telescope_actions.move_selection_next,
                    [telescope_keymap.action_send_to_qflist] = mappings_action.send_to_qflist,
                    [telescope_keymap.action_select_all] = mappings_action.select_all,
                    [telescope_keymap.action_focus_preview] = mappings_action.focus_preview,
                }
            },
            sorting_strategy = 'ascending',
            layout_strategy = 'flex',
            layout_config = {
                prompt_position = 'top',
            },
            -- winblend = 5
        },
        pickers = {
            diagnostics = mergeConfig(bottom_layout_config, {
                line_width = 0.7
            }),
            lsp_code_actions = {
                theme = 'cursor'
            },
            find_files = mergeConfig(horizontal_layout_config, {
                path_display = { 'smart' },
                wrap_results = true,
                follow = true,
            }),
            lsp_definitions = mergeConfig(bottom_layout_config, {
                layout_config = {
                    preview_width = 0.5,
                }
            }),
            lsp_references = mergeConfig(bottom_layout_config, {
                layout_config = {
                    preview_width = 0.5,
                },
                include_current_line = true,
                trim_text = true,
            }),
            quickfix = mergeConfig(vertical_layout_config, {
                layout_config = {
                    preview_height = 0.5,
                }
            }),
            buffers = mergeConfig(horizontal_layout_config, {
                only_cwd = true,
                sort_mru = true,
                sort_lastused = false,
            }),
            help_tags = horizontal_layout_config,
            live_grep = vertical_layout_config,
            grep_string = vertical_layout_config,
            current_buffer_fuzzy_find = {
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                layout_strategy = 'vertical',
                layout_config = {
                    preview_cutoff = 0.1,
                    preview_height = 0.6,
                    prompt_position = 'top',
                    mirror = true,
                    width = 0.85,
                    height = 0.85,
                },
                sorting_strategy = 'ascending',
            },
        },
        extensions = {
            ["zf-native"] = {
                file = {
                    enable = true,
                    highlight_results = true,
                    match_filename = true,
                    initial_sort = nil,
                    smart_case = true,
                },
                generic = {
                    enable = true,
                    highlight_results = true,
                    match_filename = false,
                    initial_sort = nil,
                    smart_case = true,
                },
            },
            file_browser = mergeConfig(horizontal_layout_config, {
                path = '%:p:h',
                cwd_to_path = true,
                respect_gitignore = false,
                hidden = true,
                grouped = true,
                hijack_netrw = true,
                follow_symlinks = true,
            }),
        }
    }
end

M.config = function(_, opts)
    local telescope = require('telescope')

    telescope.setup(opts)
    telescope.load_extension('zf-native')
    telescope.load_extension('file_browser')

    local telescope_augroup = vim.api.nvim_create_augroup('UserTelescopeAugroup', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        desc = 'disable cursorline when on telescope prompt',
        group = telescope_augroup,
        pattern = 'TelescopePrompt',
        command = ':setlocal nocursorline'
    })
end

M.keys = function()
    local function getVisualSelection()
        local success, text = pcall(vim.fn.getreg, 'v', 1)
        vim.fn.setreg('v', {})

        return success and (type(text) == 'string' and text:gsub('\n', '') or '') or ''
    end

    return {
        { telescope_keymap.resume,      '<Cmd>Telescope resume<CR>' },
        { telescope_keymap.buffers,     '<Cmd>Telescope buffers<CR>' },
        { telescope_keymap.jumplist,    '<Cmd>Telescope jumplist<CR>' },
        { telescope_keymap.help_tags,   '<Cmd>Telescope help_tags<CR>' },
        { telescope_keymap.file_browse, '<Cmd>Telescope file_browser<CR>' },
        { telescope_keymap.find_files,  '<Cmd>Telescope find_files<CR>' },
        {
            telescope_keymap.find_files_hidden,
            '<Cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--unrestricted<CR>'
        },
        { telescope_keymap.oldfiles,                   '<Cmd>Telescope oldfiles<CR>' },
        { telescope_keymap.search_workspace_fuzzy,     '<Cmd>Telescope grep_string search="" only_sort_text=true<CR>' },
        { telescope_keymap.search_workspace_live_grep, '<Cmd>Telescope live_grep<CR>' },
        { telescope_keymap.grep_workspace,             '<Cmd>Telescope grep_string<CR>',                              mode = 'n' },
        {
            telescope_keymap.grep_workspace,
            function()
                require('telescope.builtin').grep_string {
                    default_text = ("%s"):format(getVisualSelection()),
                    use_regex = false,
                }
            end,
            mode = 'v',
        },
        { telescope_keymap.current_buffer_fuzzy_find, '<Cmd>Telescope current_buffer_fuzzy_find<CR>' },
        { telescope_keymap.keymaps,                   '<Cmd>Telescope keymaps<CR>' },
        { telescope_keymap.git_commits,               '<Cmd>Telescope git_commits<CR>' },
        { telescope_keymap.git_bcommits,              '<Cmd>Telescope git_bcommits<CR>' },
        { telescope_keymap.git_branches,              '<Cmd>Telescope git_branches<CR>' },
    }
end

return M
