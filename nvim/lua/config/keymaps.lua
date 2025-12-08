local keymaps = {}
local commands = require('config.commands')

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

    -- INFO: quit
    vim.keymap.set('n', '<CR>', ':w<CR>')
    vim.keymap.set('n', 'ZA', ':xall')
    vim.keymap.set('n', '<C-q>', -- CTRL-Q is same as CTRL-V, so don't need the default CTRL-Q
        -- INFO: quit without saving
        function()
            if vim.bo.filetype == 'gitcommit' then
                vim.fn.feedkeys(':cq')
            else
                vim.fn.feedkeys(':qa')
            end
        end
    )

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

    -- INFO: multiple cursor-like with `cgn` and repeat with `.`
    -- NOTE: thanks to https://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
    vim.keymap.set('n', 'cn', '*``"_cgn')
    vim.keymap.set('n', 'cN', '*``"_cgN')
    vim.keymap.set('x', 'cn', 'y/\\V<C-r>=escape(@\","/")<CR><CR>``"_cgn') -- BUG: still yank to clipboard
    vim.keymap.set('x', 'cN', 'y/\\V<C-r>=escape(@\","/")<CR><CR>``"_cgN') -- BUG: still yank to clipboard

    -- INFO: enter command mode with lua prefix
    vim.keymap.set('n', '<leader>:', ':lua ')

    -- INFO: misc. keymap
    vim.keymap.set({ 'n', 'i' }, '<Esc>', '<Cmd>noh<CR><Esc>')
    -- vim.keymap.set({ 'n', 'i' }, '<C-l>', '<Cmd>noh<CR>')
    -- vim.keymap.set('n', 'dw', 'vb"_d')      -- delete a word backward
    vim.keymap.set('n', '<leader>d', '"_d') -- delete without yank
    vim.keymap.set('n', 'c', '"_c')
    vim.keymap.set('n', 'C', '"_C')
    vim.keymap.set('x', 's', '"_s')
    vim.keymap.set('n', 'x', '"_x')
    vim.keymap.set('x', 'p', 'P')           -- replace-paste without yank
    vim.keymap.set('i', '<S-Tab>', '<C-d>') -- de-tab while in insert mode
    vim.keymap.set('n', 'Y', 'y$')          -- Yank line after cursor
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

    -- INFO: quickfix keys
    vim.keymap.set('n', '<leader>q', function() require 'snacks'.picker.qflist() end)
    vim.keymap.set('n', '<leader>Q', '<Cmd>cexpr []<CR>')

    -- INFO: search word under cursor
    vim.keymap.set('n', ']]', '*', { remap = true })
    vim.keymap.set('n', '[[', '#', { remap = true })

    -- INFO: delete a character next to the cursor in INSERT mode
    vim.keymap.set('i', '<C-l>', '<Esc>lxi')

    -- INFO: search files in neovim config directory
    vim.keymap.set('n', '<leader>fnv', '<Cmd>Telescope find_files search_dirs={"~/.config/nvim"}<CR>')
    vim.keymap.set('n', '<leader>fK', function()
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
    vim.keymap.set('n', '<leader>dpft', function() vim.print(('filetype: %s'):format(vim.bo.filetype)) end) -- :echo &ft
    vim.keymap.set('n', '<leader>dpbt', function() vim.print(('buftype: %s'):format(vim.bo.buftype)) end)
    vim.keymap.set('n', '<leader>dpbn',
        function() vim.print(('buffer name: %s'):format(vim.api.nvim_buf_get_name(0))) end)
    vim.keymap.set('n', '<leader>dpwd', function() vim.print(('window: %s'):format(vim.api.nvim_get_current_win())) end)
    vim.keymap.set('n', '<leader>dphl', commands.GetHighlightGroupUnderCursor, { noremap = true, silent = false })

    -- INFO: disable ScrollWheelRight and ScrollWheelLeft in normal mode
    vim.keymap.set('n', '<ScrollWheelRight>', '<Nop>', { remap = false, silent = true })
    vim.keymap.set('n', '<ScrollWheelLeft>', '<Nop>', { remap = false, silent = true })

    -- INFO: map Shift+ScrollWheelUp to ScrollWheelRight and Shift+ScrollWheelDown to ScrollWheelLeft in normal mode
    vim.keymap.set('n', '<S-ScrollWheelUp>', '<ScrollWheelRight>', { remap = false, silent = true })
    vim.keymap.set('n', '<S-ScrollWheelDown>', '<ScrollWheelLeft>', { remap = false, silent = true })

    -- INFO: JSON-related keymaps, `jq`, filetype and format
    vim.keymap.set({ 'n', 'x' }, '<leader>jq', ':%!jq .<CR>')
    vim.keymap.set({ 'n', 'x' }, '<leader>jQ', ':%!jq . ') -- with options
    vim.keymap.set('n', '<leader>jf', function()
        vim.bo.filetype = 'json'
        vim.lsp.buf.format({ async = true })
    end)

    -- INFO: toggle window wrap
    vim.keymap.set('n', '<leader>ww', function() vim.wo.wrap = not vim.wo.wrap end)

    -- INFO: add a trailing comma to the EOL of non-empty lines, if one does not already exist
    -- NOTE: `<Cmd>noh<CR>` for removing unwanted highlight after replacement
    vim.keymap.set({ 'n', 'v' }, '<leader>c,', [[:s/\(\S\)\@<=\s*$/,/ge<CR><Cmd>noh<CR>]])
    vim.keymap.set({ 'n', 'v' }, '<leader>c<', [[:s/,$//ge<CR><Cmd>noh<CR>]])

    -- INFO: convert whitespaces between words to commas and surround each word by double quotes
    vim.keymap.set({ 'n', 'v' }, '<leader>cc', [[:s/\v(\s*)(\S+)(\s|$)/\1"\2",\3/ge | s/,$//ge<CR><Cmd>noh<CR>]])
    vim.keymap.set({ 'n', 'v' }, '<leader>cC', [[:s/[",]//ge<CR><Cmd>noh<CR>]])

    -- INFO: swap between equal and colon
    vim.keymap.set({ 'n', 'v' }, '<leader>s=', [[:s/: /=/g<CR><Cmd>noh<CR>]])
    vim.keymap.set({ 'n', 'v' }, '<leader>s+', [[:s/\v"(\w+)": "([^"]+)",?/\1=\2/g<CR><Cmd>noh<CR>]])
    vim.keymap.set({ 'n', 'v' }, '<leader>s;', [[:s/=/: /g<CR><Cmd>noh<CR>]])
    vim.keymap.set({ 'n', 'v' }, '<leader>s:', [[:s/\v(\w+)\=([^ ]+)/"\1": "\2",/g<CR><Cmd>noh<CR>]])

    -- INFO: change between dot and double quotes
    vim.keymap.set({ 'n', 'v' }, '<leader>s.', [[:s/\(\w\+\)\["\(\w\+\)"\]/\1.\2/g<CR><Cmd>noh<CR>]])
    vim.keymap.set({ 'n', 'v' }, '<leader>s>', [[:s/\(\w\+\)\.\(\w\+\)/\1\["\2"\]/g<CR><Cmd>noh<CR>]])

    -- INFO: remove blank lines and lines containing only whitespaces
    vim.keymap.set('v', '<leader>-', [[:g/^\s*$/d<CR><Cmd>noh<CR>]]) -- got unwanted highlight after replacement

    -- INFO: source current config line/file
    vim.keymap.set('n', '<leader>xn', ':.lua<CR>', { desc = 'Execute the current line' })
    vim.keymap.set('x', '<leader>xn', ':lua<CR>', { desc = 'Execute the selected visual lines' })
    vim.keymap.set('n', '<leader><leader>x', function()
        vim.cmd('source %')
        vim.notify('Sourced %')
    end, { desc = 'Execute the current file' })
    -- INFO: lazy.nvim reload plugin (shift+5 is %)
    vim.keymap.set('n', '<leader><leader>5', ':Lazy reload ')
    -- INFO: execute the selected line(s) in the shell
    vim.keymap.set('n', '<leader>xs', ':.w !sh<CR>', { desc = 'Execute the current line in the shell', silent = true })
    vim.keymap.set('x', '<leader>xs', ':w !sh<CR>',
        { desc = 'Execute the current line or selected lines in the shell', silent = true })
    -- INFO: execute the selected line(s) with the tmux command
    vim.keymap.set({ 'n', 'x' }, '<leader>xt', commands.apply_function(commands.run_tmux_expr),
        { desc = 'Execute the current line or selected lines with `tmux ` prepended in the shell', silent = true })

    -- INFO: append the repeated trailing '-' not exceeding 80 columns
    -- vim.keymap.set('n', '<leader>--', [[:%s/\s\+$//e<CR><Cmd>noh<CR>A<space><Esc>80A-<Esc>d80|0]])
    vim.keymap.set('n', '<leader>--', function() commands.append_repeated_trailing_characters('-') end)
    vim.keymap.set('n', '<leader>-=', function() commands.append_repeated_trailing_characters('=') end)
    vim.keymap.set('n', '<leader>-#', function() commands.append_repeated_trailing_characters('#') end)
    vim.keymap.set('n', '<leader>-_', function() commands.append_repeated_trailing_characters('_') end)

    -- INFO: toggle between double quote and single quotes
    vim.keymap.set({ 'n', 'v' }, [[<leader>']], [[:s/"/'/g<CR><Cmd>noh<CR>]])
    vim.keymap.set({ 'n', 'v' }, [[<leader>"]], [[:s/'/"/g<CR><Cmd>noh<CR>]])

    vim.keymap.set('x', '<leader>em', 's<C-r>=eval(@")<CR><ESC>', { desc = 'Evaluate expression in visual' })
    vim.keymap.set('n', '<leader>em', 'Vs<C-r>=eval(@")<CR><ESC>', { desc = 'Evaluate expression in normal' })

    -- INFO: toggle global show_inlay_hint
    vim.keymap.set('n', '<leader>ih', function()
        vim.g.show_inlay_hint = not vim.g.show_inlay_hint
        vim.lsp.inlay_hint.enable(vim.g.show_inlay_hint)
    end, { noremap = true, silent = false })
end

-- INFO: LSP keymap
keymaps.lsp = {
    definitions         = { key = 'gd', cmd = function() require 'snacks'.picker.lsp_definitions() end },
    type_definitions    = { key = 'gt', cmd = function() require 'snacks'.picker.lsp_type_definitions() end },
    reference           = { key = 'gr', cmd = function() require 'snacks'.picker.lsp_references() end },
    implementation      = { key = 'gi', cmd = function() require 'snacks'.picker.lsp_implementations() end },
    signature_help      = { key = 'gs', cmd = vim.lsp.buf.signature_help },
    diagnostic          = { key = '<leader>ld', cmd = function() require 'snacks'.picker.diagnostics() end },
    document_symbol     = { key = '<leader>ls', cmd = function() require 'snacks'.picker.lsp_symbols() end },
    document_color      = { key = '<leader>lc', cmd = vim.lsp.document_color.color_presentation },
    code_action         = { key = '<leader>lx', cmd = vim.lsp.buf.code_action },
    format              = { key = '<leader>ff', cmd = function() vim.lsp.buf.format({ async = true }) end },
    hover               = {
        key = 'K',
        cmd = function()
            return vim.diagnostic.open_float({ scope = 'cursor' }) or vim.lsp.buf.hover()
        end
    },
    jump_to_context     = { key = '[C', cmd = function() require('treesitter-context').go_to_context() end },
    next_diagnostic     = { key = 'zn', cmd = function() require('plugins.lsp-config')[2].jumpWithVirtLineDiags(1) end },
    previous_diagnostic = { key = 'zN', cmd = function() require('plugins.lsp-config')[2].jumpWithVirtLineDiags(-1) end },
}

-- INFO: live-rename keymap
keymaps.rename = {
    rename = '<leader>lr',
    rename_clean = '<leader>lR',
}

-- INFO: Treesitter
keymaps.treesitter = {
    incremental_selection = {
        init_selection = '<Tab>]',
        node_incremental = '<Tab>]',
        node_decremental = '<Tab>[',
    },
    textobjects = {
        repeat_move = {
            repeat_last_move_next = '];',
            repeat_last_move_previous = '[;',
        },
        move = {
            goto_next_start = {
                [']f'] = '@function.outer',
                [']c'] = '@comment.outer',
                [']u'] = '@conditional.outer',
                [']l'] = '@loop.outer',
                [']]'] = { query = { '@block.outer', '@local_declaration' } },
                [']a'] = '@parameter.outer',
            },
            goto_next_end = {
                [']F'] = '@function.outer',
                [']C'] = '@comment.outer',
                [']U'] = '@conditional.outer',
                [']L'] = '@loop.outer',
                [']}'] = { query = { '@block.outer', '@local_declaration' } },
                [']A'] = '@parameter.outer',
            },
            goto_previous_start = {
                ['[f'] = '@function.outer',
                ['[c'] = '@comment.outer,',
                ['[u'] = '@conditional.outer,',
                ['[l'] = '@loop.outer',
                ['[['] = { query = { '@block.outer' } },
                ['[a'] = '@parameter.outer',
            },
            goto_previous_end = {
                ['[F'] = '@function.outer',
                ['[C'] = '@comment.outer,',
                ['[U'] = '@conditional.outer,',
                ['[L'] = '@loop.outer',
                ['[{'] = { query = { '@block.outer' } },
                ['[A'] = '@parameter.outer',
            },
        },
        swap = {
            -- NOTE: for others, use `sibling-swap.nvim`
            swap_next = {
                ['<leader>sm'] = '@function.outer',
                ['<leader>sc'] = '@class.outer',
            },
            swap_previous = {
                ['<leader><leader>sm'] = '@function.outer',
                ['<leader><leader>sc'] = '@class.outer',
            },
        },
        peek_definition_code = {
            ['gM'] = '@function.outer',
            ['gC'] = '@class.outer',
        },
        various_textobjs = {
            disabledKeymaps = {
                'r',  -- restOfParagraph
                'av', -- value outer
                'iv', -- value inner
                'ak', -- key outer
                'ik', -- key inner
                'ay', -- pyTripleQuotes
                'iy', -- pyTripleQuotes
                'ao', -- anyBracket outer
                'io', -- anyBracket inner
                '|',  -- column, conflict with the origin *bar*
            },
            delete_surrounding_indentation = 'dsi',
            value_outer = 'aV',
            value_inner = 'iV',
            key_outer = 'aK',
            key_inner = 'iK',
            pyTripleQuotes_outer = 'aT',
            pyTripleQuotes_inner = 'iT',
        },
    }
}

-- INFO: Lazy keymap
keymaps.lazy = {
    open = '<leader>L',
}

-- INFO: Mason keymap
keymaps.mason = {
    open = '<leader>P',
}

-- INFO: jot keymap
keymaps.jot = {
    toggle = '<leader>n',
}

-- INFO: focus keymap
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
    next_hunk        = ']h',
    prev_hunk        = '[h',
    stage_hunk       = '<leader>hs',
    undo_stage_hunk  = '<leader>hu',
    reset_hunk       = '<leader>hr',
    preview_hunk     = '<leader>hp',
    blame_line       = '<leader>hb',
    toggle_blame     = '<leader>hB',
    diff_this        = '<leader>hd',
    toggle_highlight = '<leader>hl',
    toggle_word_diff = '<leader>hw',
    toggle_deleted   = '<leader>hx',
}

-- INFO: git-conflict keymap
keymaps.gitconflict = {
    toggle_qflist = '<leader>x',
}

-- INFO: snacks picker keymap
keymaps.snacks = {
    picker         = {
        grep_workspace        = 'gw',
        search_workspace      = '<leader>fw',
        search_buffers        = '<leader>/',
        buffers               = '<C-_>', -- `<C-_>` is actually `<C-/>`
        find_files            = '<leader>fs',
        resume                = '<leader>;',
        jumplist              = '<leader>ju',
        oldfiles              = '<leader>fo',
        help_tags             = '<leader>?',
        keymaps               = '<leader>fk',
        action_select_all     = '<m-a>',
        action_focus_preview  = '<m-space>',
        action_send_to_qflist = '<C-q>',
        action_scroll_up      = '<C-u>',
        action_scroll_down    = '<C-d>',
    },
    bufdelete      = {
        delete = '<leader>wQ',
    },
    terminal       = {
        toggle = '<leader>t',
        lazygit = '<leader>g',
        lazygit_file_history = '<leader>G',
    },
    gitbrowse      = '<leader>gb',
    git_blame_line = '<leader>gB',
}

-- INFO: oil keymap
keymaps.oil = {
    open_float = '<leader><Tab>',
}

-- INFO: todocomments keymap
keymaps.todocomments = {
    toggle    = '<Bslash>c',
    next_todo = ']t',
    prev_todo = '[t',
}

-- INFO: marks keymap
keymaps.marks = {
    next   = "'",
    prev   = '"',
    toggle = "m'",
    clear  = 'md',
    list   = '<leader>m',
}

-- INFO: ufo keymap
keymaps.ufo = {
    open_all    = 'zR',
    open_except = 'zr',
    close_all   = 'zM',
    close_with  = 'zm',
}

-- INFO: resession keymaps
keymaps.resession = {
    save   = '<leader>ss',
    delete = '<leader>sd',
}

-- INFO: noice keymaps
keymaps.noice = {
    history          = '<leader>M',
    docs_scroll_up   = '<C-u>',
    docs_scroll_down = '<C-d>',
}

-- INFO: flash keymaps
keymaps.flash = {
    flash              = 's',
    flash_treesitter   = 'zs',
    flash_current_word = 'S',
    flash_continue     = '\\s',
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
    watch            = '<leader>tw',
    watch_file       = '<leader>tW',
    run_nearest      = '<leader>tn',
    stop_nearest     = '<leader>ts',
    debug_nearest    = '<leader>td',
    attach_nearest   = '<leader>ta',
    run_current_file = '<leader>tf',
    summary          = '<leader>tt',
    output_open      = '<leader>to',
    output_last      = '<leader>tl',
    output_panel     = '<leader>tp',
}

-- INFO: Codeium
keymaps.codeium = {
    accept      = '<M-;>',
    accept_word = "<M-'>",
    next        = '<M-j>',
    previous    = '<M-k>',
    clear       = '<M-c>',
    chat        = '<leader>C',
}

-- INFO: DAP
keymaps.dap = {
    ui                    = '<leader>dap',
    breakpoint            = '<leader>dbb',
    breakpoint_condition  = '<leader>dbB',
    clear_all_breakpoints = '<leader>dbr',
    continue              = '<leader>dbc',
    terminate             = '<leader>dbt',
    log_point             = '<leader>dbl',
    step_over             = '<leader>dbo',
    step_into             = '<leader>dbi',
    step_out              = '<leader>dbu',
    run_to_cursor         = '<leader>dbC',
    eval                  = '<leader>dbe',
    python                = {
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
    open          = '<leader>dv',
    close         = '<leader>dc',
    current_file  = '<leader>df',
    file_history  = '<leader>dF',
    toggle_files  = '<leader>dt',
    compare_head  = '<leader>dh',
    review_branch = '<leader>dr',
    merge_request = '<leader>dmr',
}

-- INFO: undotree
keymaps.undotree = {
    open = '<leader>u',
}

-- INFO: harpoon
keymaps.harpoon = {
    toggle_quick_menu = '<leader>`',
    add_file          = '<leader><leader>`',
    nav_next          = 'L',
    nav_prev          = 'H',
    nav_file_1        = "'1",
    nav_file_2        = "'2",
    nav_file_3        = "'3",
    nav_file_4        = "'4",
    nav_file_5        = "'5",
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
    toggle                = '<leader>Z<leader>',
    toggle_size           = '<leader>Z',
    twilight_current_line = '<leader>z',
    twilight_context      = '<leader>z<leader>',
}

-- INFO: neowords
keymaps.neowords = {
    old_w = 'W',
    old_e = 'E',
    old_b = 'B',
    new_w = 'w',
    new_e = 'e',
    new_b = 'b',
}

-- INFO: codecompanion keymap
keymaps.codecompanion = {
    new_chat = '<leader>A',
    toggle = '<leader>a',
    inline = 'ga',
}

-- INFO: sidekick keymap
keymaps.sidekick = {
    apply_nes = '<Tab>',
    toggle = '<leader>s',
    prompt = '<leader>S',
}

-- INFO: hbac keymap
keymaps.hbac = {
    toggle_pin = '<leader>fp',
}

-- INFO: cloak keymap
keymaps.cloak = {
    toggle       = '<leader><leader>8',
    preview_line = '<leader>8',
}

-- INFO: inc-rename keymap
keymaps.inc_rename = {
    rename_current_word = '<leader>lr',
    rename_empty        = '<leader>lR',
}

-- INFO: obsidian keymap
keymaps.obsidian = {
    open_in_obsidian       = '<leader>oo',
    open_in_obsidian_query = '<leader>oO',
    search                 = '<leader>os',
    workspace              = '<leader>ow',
    quick_switch           = '<leader>ok',
    paste_image            = '<leader>oi',
    rename                 = '<leader>or',
    toggle_checkbox        = '<leader>ot',
}

-- INFO: neo-tree keymap
keymaps.neotree = {
    toggle = '<leader>nt',
}

-- INFO: vim-visual-multi keymap
keymaps.vim_visual_multi = {
    find_under         = '<C-n>',
    find_subword_under = '<C-n>',
}

return keymaps
