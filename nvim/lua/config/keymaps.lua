local keymaps = {}

-- NOTE: helper functions
local function open_with_qflist(options)
    vim.fn.setqflist({}, ' ', options)
    vim.cmd 'TroubleToggle quickfix'
end

local function set_multiple_cursors_keymaps()
    -- NOTE: thanks to https://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
    vim.keymap.set('n', 'cn', '*``"_cgn')
    vim.keymap.set('n', 'cN', '*``"_cgN')
    vim.keymap.set('x', 'cn', 'y/\\V<C-r>=escape(@\","/")<CR><CR>``"_cgn') -- BUG: still yank to clipboard
    vim.keymap.set('x', 'cN', 'y/\\V<C-r>=escape(@\","/")<CR><CR>``"_cgN') -- BUG: still yank to clipboard
end

keymaps.setup = function()
    -- INFO: disable <Space> for moving the cursor
    vim.keymap.set('n', '<Space>', '')

    -- INFO: use <Esc> to exit terminal-mode
    -- vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

    -- INFO: composite escape keys
    vim.keymap.set('i', 'jj', '<Esc>')
    vim.keymap.set('i', 'jk', '<Esc>')

    vim.keymap.set('i', '<C-j>', '<Down>')
    vim.keymap.set('i', '<C-k>', '<Up>')

    -- INFO: move up / down by visible lines with no [count]
    vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
    vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })

    -- INFO: keep the cursor still when join lines
    vim.keymap.set('n', 'J', 'mzJ`z')

    -- INFO: movement in Command mode
    vim.keymap.set('c', '<C-A>', '<Home>')
    vim.keymap.set('c', '<C-j>', '<Left>')
    vim.keymap.set('c', '<C-k>', '<Right>')
    vim.keymap.set('c', '<C-h>', '<S-Left>')
    vim.keymap.set('c', '<C-l>', '<S-Right>')

    -- INFO: command-line abbreviations
    -- vim.keymap.set('c', 'W', 'w')
    -- vim.keymap.set('c', 'W!', 'w!')
    -- vim.keymap.set('c', 'Wq', 'wq')
    -- vim.keymap.set('c', 'WQ', 'wq')
    -- vim.keymap.set('c', 'Wa', 'wa')
    -- vim.keymap.set('c', 'Q', 'q')
    -- vim.keymap.set('c', 'Q!', 'q!')
    -- vim.keymap.set('c', 'Qa', 'qa')
    -- vim.keymap.set('c', 'QA', 'qa')

    -- INFO: add undo break points
    vim.keymap.set('i', ',', ',<C-g>u')
    vim.keymap.set('i', '.', '.<C-g>u')
    vim.keymap.set('i', '!', '!<C-g>u')
    vim.keymap.set('i', '?', '?<C-g>u')

    -- INFO: windows/buffers navigated keys
    vim.keymap.set('n', 'gh', '<Cmd>bnext<CR>')
    vim.keymap.set('n', 'gl', '<Cmd>bprev<CR>')
    vim.keymap.set('n', '<leader>wq', '<C-w>q')

    -- INFO: replace the current word from the current line onward
    vim.keymap.set('n', '<leader>r', [[:.,$s/\<<C-r><C-w>\>/<C-r><C-w>/gcI<Left><Left><Left><Left>]])
    set_multiple_cursors_keymaps()

    -- INFO: misc. keymap
    vim.keymap.set({ 'n', 'i' }, '<Esc>', '<Cmd>noh<CR><Esc>')
    -- vim.keymap.set({ 'n', 'i' }, '<C-l>', '<Cmd>noh<CR>')
    vim.keymap.set('n', 'dw', 'vb"_d')      -- delete a word backward
    vim.keymap.set('n', '<leader>d', '"_d') -- delete without yank
    vim.keymap.set('n', 'c', '"_c')
    vim.keymap.set('n', 'C', '"_C')
    vim.keymap.set('x', 's', '"_s')
    vim.keymap.set('n', 'x', '"_x')
    vim.keymap.set('x', 'p', '"_c<C-r>+<Esc>') -- replace-paste without yank
    vim.keymap.set('i', '<S-Tab>', '<C-d>')    -- de-tab while in insert mode
    vim.keymap.set('n', 'Y', 'y$')             -- Yank line after cursor
    -- vim.keymap.set('n', 'P', '<cmd>pu<CR>') -- Paste on new line
    -- vim.keymap.set('v', '<', '<gv')
    -- vim.keymap.set('v', '>', '>gv')

    -- INFO: resize window
    vim.keymap.set('n', '<C-w>h', '<C-w><')
    vim.keymap.set('n', '<C-w>l', '<C-w>>')
    vim.keymap.set('n', '<C-w>k', '<C-w>+')
    vim.keymap.set('n', '<C-w>j', '<C-w>-')
    vim.keymap.set('n', '-', '<Cmd>vertical resize -10<CR>', { silent = true })
    vim.keymap.set('n', '=', '<Cmd>vertical resize +10<CR>', { silent = true })
    vim.keymap.set('n', '_', '<Cmd>resize -10<CR>', { silent = true })
    vim.keymap.set('n', '+', '<Cmd>resize +10<CR>', { silent = true })

    -- INFO: remap jump keys
    vim.keymap.set('n', '<M-o>', '<C-i>') -- <C-i> is <Tab>, so we need to replace it with another
    -- vim.keymap.set('n', '<C-k>', '<C-o>')

    -- INFO: quickfix keys
    vim.keymap.set('n', '<leader>q', '<Cmd>Telescope quickfix<CR>')
    vim.keymap.set('n', '<leader>Q', '<Cmd>cexpr []<CR>')

    -- INFO: search word under cursor (recursive called `hlslens`)
    -- vim.keymap.set('n', ']]', '*', { remap = true })
    -- vim.keymap.set('n', '[[', '#', { remap = true })

    -- INFO: delete a character next to the cursor in INSERT mode
    vim.keymap.set('i', '<C-l>', '<Esc>lxi')

    -- INFO: search files in neovim config directory
    vim.keymap.set('n', '<leader>fnv', '<Cmd>Telescope find_files search_dirs={"~/.config/nvim"}<CR>')
    vim.keymap.set('n', '<leader>kM', function()
        local keymaps_file_path = '~/.config/nvim/lua/config/keymaps.lua'
        vim.cmd.edit(keymaps_file_path)
        vim.api.nvim_buf_set_keymap(vim.fn.bufnr(), 'n', 'qq', '<Cmd>bdelete<CR>', { noremap = true })
        require('telescope.builtin').current_buffer_fuzzy_find({})
    end)

    -- INFO: open treesitter's language tree
    vim.keymap.set('n', '<leader>it', function()
        vim.cmd('InspectTree')
        vim.api.nvim_buf_set_keymap(vim.fn.bufnr(), 'n', 'q', '<Cmd>bdelete<CR>', { noremap = true })
    end)

    -- INFO: development utility keymaps
    vim.keymap.set('n', '<leader>dpft', function() vim.print(('filetype: %s'):format(vim.bo.filetype)) end)
    vim.keymap.set('n', '<leader>dpbt', function() vim.print(('buftype: %s'):format(vim.bo.buftype)) end)
    vim.keymap.set('n', '<leader>dpbn',
        function() vim.print(('buffer name: %s'):format(vim.api.nvim_buf_get_name(0))) end)
    vim.keymap.set('n', '<leader>dpwd', function() vim.print(('window: %s'):format(vim.api.nvim_get_current_win())) end)

    -- INFO: disable ScrollWheelRight and ScrollWheelLeft in normal mode
    vim.keymap.set('n', '<ScrollWheelRight>', '<Nop>', { remap = false, silent = true })
    vim.keymap.set('n', '<ScrollWheelLeft>', '<Nop>', { remap = false, silent = true })

    -- INFO: map Shift+ScrollWheelUp to ScrollWheelRight and Shift+ScrollWheelDown to ScrollWheelLeft in normal mode
    vim.keymap.set('n', '<S-ScrollWheelUp>', '<ScrollWheelRight>', { remap = false, silent = true })
    vim.keymap.set('n', '<S-ScrollWheelDown>', '<ScrollWheelLeft>', { remap = false, silent = true })
end

-- INFO: LSP keymap
keymaps.lsp = {
    definitions      = { key = 'gd', cmd = '<Cmd>Telescope lsp_definitions<CR>' },
    type_definitions = { key = 'gt', cmd = '<Cmd>Telescope lsp_type_definitions<CR>' },
    reference        = { key = 'gr', cmd = '<Cmd>Telescope lsp_references<CR>' },
    implementation   = { key = 'gi', cmd = '<Cmd>Telescope lsp_implementations<CR>' },
    signature_help   = { key = 'gs', cmd = vim.lsp.buf.signature_help },
    diagnostic       = { key = '<leader>ld', cmd = '<Cmd>Telescope diagnostics<CR>' },
    document_symbol  = { key = '<leader>ls', cmd = '<Cmd>Telescope lsp_document_symbols<CR>' },
    rename           = { key = '<leader>lr', cmd = function() require 'config.rename-utils'.rename_to_qflist() end },
    rename_clean     = { key = '<leader>lR', cmd = function() require 'config.rename-utils'.rename_clean_placeholder() end },
    code_action      = { key = '<leader>lx', cmd = vim.lsp.buf.code_action },
    format           = { key = '<leader>ff', cmd = function() vim.lsp.buf.format({ async = true }) end },
    hover            = {
        key = 'K',
        cmd = function()
            local ufo_loaded, ufo = pcall(require, 'ufo')
            if ufo_loaded then
                if ufo.peekFoldedLinesUnderCursor() then return end
            end
            return vim.diagnostic.open_float({ scope = 'cursor' }) or vim.lsp.buf.hover()
        end
    },
    jump_to_context  = { key = '[C', cmd = function() require('treesitter-context').go_to_context() end },
}

-- INFO: Treesitter
keymaps.treesitter = {
    incremental_selection = {
        init_selection = '<M-Tab>',
        node_incremental = '<M-Tab>',
        node_decremental = '<S-Tab>',
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
        },
        move = {
            enable = true,
            goto_next_start = {
                [']m'] = '@function.outer',
                [']/'] = '@comment.outer',
                [']i'] = '@conditional.outer',
                [']l'] = '@loop.outer',
                [']]'] = '@block.outer',
                [']a'] = '@parameter.outer',
                [']b'] = '@block_node.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']?'] = '@comment.outer',
                [']I'] = '@conditional.outer',
                [']L'] = '@loop.outer',
                [']}'] = '@block.outer',
                [']A'] = '@parameter.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[/'] = '@comment.outer,',
                ['[i'] = '@conditional.outer,',
                ['[l'] = '@loop.outer',
                ['[['] = '@block.outer',
                ['[a'] = '@parameter.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[?'] = '@comment.outer,',
                ['[I'] = '@conditional.outer,',
                ['[L'] = '@loop.outer',
                ['[{'] = '@block.outer',
                ['[A'] = '@parameter.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<C-s>a'] = '@parameter.inner',
                ['<C-s>m'] = '@function.outer',
                ['<C-s>c'] = '@class.outer',
            },
            swap_previous = {
                ['<C-s>A'] = '@parameter.inner',
                ['<C-s>M'] = '@function.outer',
                ['<C-s>C'] = '@class.outer',
            },
        },
        peek_definition_code = {
            ['H'] = '@function.outer',
            ['L'] = '@class.outer',
        },
        various_textobjs = {
            disabledKeymaps = {
                'r',  -- restOfParagraph
                'av', -- value outer
                'iv', -- value inner
                'ay', -- pyTripleQuotes
                'iy', -- pyTripleQuotes
                'ao', -- anyBracket outer
                'io', -- anyBracket inner
            },
            delete_surrounding_indentation = 'dsi',
            value_outer = 'aV',
            value_inner = 'iV',
            pyTripleQuotes_outer = 'aT',
            pyTripleQuotes_inner = 'iT',
        },
    }
}

-- INFO: Lazy keymap
keymaps.lazy = {
    open = '<leader>P',
}

-- INFO: Focus keymap
keymaps.focus = {
    toggle_enable = '<Bslash>f',
    toggle_size   = '<Bslash>F',
    split_cycle   = '<C-;>',
    split_left    = '<C-h>',
    split_right   = '<C-l>',
    split_up      = '<C-k>',
    split_down    = '<C-j>',
}

-- INFO: GitSign keymap
keymaps.gitsigns = {
    next_hunk    = ']h',
    prev_hunk    = '[h',
    stage_hunk   = '<leader>Hs',
    reset_hunk   = '<leader>Hr',
    preview_hunk = '<leader>Hp',
    blame_line   = '<leader>Hb',
    toggle_blame = '<leader>HB',
    diff_this    = '<leader>Hd',
}

-- INFO: git-conflict keymap
keymaps.gitconflict = {
    toggle_qflist = '<leader>x',
}

-- INFO: Telescope keymap
keymaps.telescope = {
    grep_workspace             = 'gw',
    search_workspace_fuzzy     = '<leader>sf',
    search_workspace_live_grep = '<leader>sg',
    buffers                    = '<leader><tab>',
    find_files                 = '<leader>fs',
    find_files_hidden          = '<leader>fS',
    resume                     = '<leader>;',
    jumplist                   = '<leader>ju',
    oldfiles                   = '<leader>fo',
    file_browse                = '<leader>fb',
    help_tags                  = '<leader>?',
    action_send_to_qflist      = '<m-q>',
    action_select_all          = '<m-a>',
    action_focus_preview       = '<m-space>',
    current_buffer_fuzzy_find  = '<leader>/',
    keymaps                    = '<leader>km',
    git_commits                = '<leader>fgc',
    git_bcommits               = '<leader>fgC',
    git_branches               = '<leader>fgb',
    registers                  = '<leader>fr',
}

-- INFO: Todocomments keymap
keymaps.todocomments = {
    toggle    = '<Bslash>c',
    next_todo = ']t',
    prev_todo = '[t',
}

-- INFO: Terminal & ToggleTerm keymap
keymaps.toggleterm = {
    toggle = '<Bslash>t',
    lazygit = '<leader>g',
    lazygit_file_history = '<leader>G',
}

-- INFO: Marks keymap
keymaps.marks = {
    next    = 'mm',
    prev    = 'MM',
    toggle  = "m'",
    preview = 'm"',
    clear   = 'md',
    list    = '<leader>m',
}

-- INFO: ufo keymap
keymaps.ufo = {
    open_all    = 'zR',
    open_except = 'zr',
    close_all   = 'zM',
    close_with  = 'zm',
}

-- INFO: hlslens keymap
keymaps.hlslens = {
    search_next = 'n',
    search_prev = 'N',
    word_next   = '*',
    word_prev   = '#',
    go_next     = 'g*',
    go_prev     = 'g#',
}

-- INFO: resession keymaps
keymaps.resession = {
    save   = '<leader>ss',
    delete = '<leader>sd',
}

-- INFO: Noice keymaps
keymaps.noice = {
    history          = '<leader>M',
    docs_scroll_up   = '<C-u>',
    docs_scroll_down = '<C-d>',
}

-- INFO: flash keymaps
keymaps.flash = {
    flash              = 's',
    flash_treesitter   = 'zs',
    flash_current_word = 'cs',
    flash_continue     = 'S',
}

-- INFO: mini.bufremove keymap
keymaps.bufremove = {
    delete = '<leader>wQ',
}

-- INFO: mini.move keymap
keymaps.move = {
    move_up    = '<M-K>',
    move_down  = '<M-J>',
    move_left  = '<M-H>',
    move_right = '<M-L>',
}

-- INFO: search-replace keymap
keymaps.search_replace = {
    single_open                   = '<leader>sr',
    multi_open                    = '<leader>sR',
    visual_selection_charwise     = '<M-c>',
    visual_selection_current_word = '<M-r>',
}

-- INFO: treesj keymap
keymaps.treesj = {
    toggle = '<leader>jl',
}

-- INFO: refactoring
keymaps.refactoring = {
    extract_function         = '<leader>le',
    extract_function_to_file = '<leader>lE',
    extract_variable         = '<leader>lv',
    inline_variable          = '<leader>li',
    extract_block            = '<leader>lb',
    extract_block_to_file    = '<leader>lB',
    print_var                = '<leader>pv',
    debug_cleanup            = '<leader>lc',
}

-- INFO: Neotest
keymaps.neotest = {
    run_nearest      = '<leader>tn',
    stop_nearest     = '<leader>ts',
    debug_nearest    = '<leader>td',
    attach_nearest   = '<leader>ta',
    run_current_file = '<leader>tf',
    summary          = '<leader>tt',
    output_panel     = '<leader>to',
}

-- INFO: Codeium
keymaps.codeium = {
    accept   = '<M-;>',
    next     = '<M-j>',
    previous = '<M-k>',
    clear    = '<M-c>',
}

-- INFO: DAP
keymaps.dap = {
    ui = '<leader>dap',
    breakpoint = '<leader>dbb',
    breakpoint_condition = '<leader>dbB',
    continue = '<leader>dbc',
    terminate = '<leader>dbt',
    log_point = '<leader>dbl',
    step_over = '<leader>dbo',
    step_into = '<leader>dbi',
    step_out = '<leader>dbu',
    python = {
        method = '<leader>dbm',
        class = '<leader>dbM',
        selection = '<leader>dbs',
    },
}

-- INFO: swenv
keymaps.swenv = {
    pick = '<leader>pe',
}

-- INFO: diffview
keymaps.diffview = {
    open         = '<leader>dv',
    close        = '<leader>dc',
    current_file = '<leader>df',
    file_history = '<leader>dF',
    toggle_files = '<leader>dt',
    compare_head = '<leader>dh',
}

-- INFO: undotree
keymaps.undotree = {
    open = '<leader>u',
}

-- INFO: harpoon
keymaps.harpoon = {
    toggle_quick_menu = '<leader>hp',
    add_file = '<leader>ha',
    nav_next = 'L',
    nav_prev = 'H',
    nav_file_1 = 'm1',
    nav_file_2 = 'm2',
    nav_file_3 = 'm3',
    nav_file_4 = 'm4',
    nav_file_5 = 'm5',
    go_to_terminal_1 = '<Bslash>1',
    go_to_terminal_2 = '<Bslash>2',
    go_to_terminal_3 = '<Bslash>3',
}

-- INFO: flutter-tools
keymaps.flutter_tools = {
    run            = '<leader>fT',
    quit           = '<leader>ftq',
    devices        = '<leader>ftd',
    detach         = '<leader>ftx',
    emulators      = '<leader>fte',
    reload         = '<leader>ftr',
    restart        = '<leader>ftR',
    rename         = '<leader>ftc',
    outline_toggle = '<leader>fto',
    visual_debug   = '<leader>ftv',
}

-- INFO: zen-mode
keymaps.zen_mode = {
    toggle = '<leader>z',
    toggle_size = '<leader>Z',
    twilight_current_line = '<leader>tw',
    twilight_context = '<leader>tW',
}

-- INFO: nvim-spider
keymaps.spider = {
    old_w = 'W',
    old_e = 'E',
    old_b = 'B',
    new_w = 'w',
    new_e = 'e',
    new_b = 'b',
}

-- INFO: copilot keymap
keymaps.copilot = {
    next = '<m-]>',
    prev = '<m-[>',
}

-- INFO: copilot chat keymap
keymaps.copilot_chat = {
    toggle = '<leader>aa',
    quick_chat = '<leader>aq',
    commit_staged = '<leader>am',
    commit = '<leader>aM',
}

-- INFO: hbac keymap
keymaps.hbac = {
    toggle_pin = '<leader>p',
}

return keymaps
