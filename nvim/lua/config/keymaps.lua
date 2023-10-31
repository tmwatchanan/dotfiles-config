local keymaps = {}

-- NOTE: helper functions
local function open_with_qflist(options)
    vim.fn.setqflist({}, ' ', options)
    vim.cmd 'TroubleToggle quickfix'
end

keymaps.setup = function()
    -- INFO: disable <Space> for moving the cursor
    vim.keymap.set('n', '<Space>', '')

    -- INFO: composite escape keys
    vim.keymap.set('i', 'jj', '<Esc>')
    vim.keymap.set('i', 'jk', '<Esc>')

    vim.keymap.set('i', '<C-j>', '<Down>')
    vim.keymap.set('i', '<C-k>', '<Up>')

    -- INFO: move up / down by visible lines with no [count]
    vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
    vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })

    -- INFO: move lines up / down in linewise Visual mode
    vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
    vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

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
    vim.keymap.set('n', 'H', '<Cmd>bnext<CR>')
    vim.keymap.set('n', 'L', '<Cmd>bprev<CR>')
    vim.keymap.set('n', 'wq', '<C-w>q')

    -- INFO: replace the current word from the current line onward
    vim.keymap.set('n', '<leader>r', [[:.,$s/\<<C-r><C-w>\>/<C-r><C-w>/gcI<Left><Left><Left><Left>]])

    -- INFO: misc. keymap
    vim.keymap.set({ 'n', 'i' }, '<Esc>', '<Cmd>noh<CR><Esc>')
    -- vim.keymap.set({ 'n', 'i' }, '<C-l>', '<Cmd>noh<CR>')
    vim.keymap.set('n', 'dw', 'vb"_d')      -- delete a word backward
    vim.keymap.set('n', '<leader>d', '"_d') -- delete without yank
    vim.keymap.set('n', 'x', '"_x')
    vim.keymap.set('v', 'p', '"_dP')        -- replace-paste without yank
    vim.keymap.set('i', '<S-Tab>', '<C-d>') -- de-tab while in insert mode
    vim.keymap.set('n', 'Y', 'y$')          -- Yank line after cursor
    -- vim.keymap.set('n', 'P', '<cmd>pu<CR>') -- Paste on new line
    vim.keymap.set('v', '<', '<gv')
    vim.keymap.set('v', '>', '>gv')

    -- INFO: resize window
    vim.keymap.set('n', '<C-w>h', '<C-w><')
    vim.keymap.set('n', '<C-w>l', '<C-w>>')
    vim.keymap.set('n', '<C-w>k', '<C-w>+')
    vim.keymap.set('n', '<C-w>j', '<C-w>-')
    vim.keymap.set('n', '<C-,>', '<Cmd>vertical resize -10<CR>', { silent = true })
    vim.keymap.set('n', '<C-.>', '<Cmd>vertical resize +10<CR>', { silent = true })
    vim.keymap.set('n', '<C-\'>', '<Cmd>resize +10<CR>', { silent = true })
    vim.keymap.set('n', '<C-/>', '<Cmd>resize -10<CR>', { silent = true })

    -- INFO: remap jump keys
    vim.keymap.set('n', '<M-o>', '<C-i>') -- <C-i> is <Tab>, so we need to replace it with another
    -- vim.keymap.set('n', '<C-k>', '<C-o>')

    -- INFO: quickfix keys
    vim.keymap.set('n', '<leader>q', '<Cmd>TroubleToggle quickfix<CR>')
    vim.keymap.set('n', '<leader>Q', '<Cmd>cexpr []<CR>')

    -- INFO: search word under cursor (recursive called `hlslens`)
    -- vim.keymap.set('n', ']]', '*', { remap = true })
    -- vim.keymap.set('n', '[[', '#', { remap = true })

    -- INFO: delete a acharacter next to the cursor in INSERT mode
    vim.keymap.set('i', '<C-l>', '<Esc>lxi')
end

-- INFO: LSP keymap
keymaps.lsp = {
    definitions      = { key = 'gd', cmd = '<Cmd>TroubleToggle lsp_definitions<CR>' },
    type_definitions = { key = 'gt', cmd = '<Cmd>TroubleToggle lsp_type_definitions<CR>' },
    reference        = { key = 'gr', cmd = '<Cmd>TroubleToggle lsp_references<CR>' },
    signature_help   = { key = 'gs', cmd = vim.lsp.buf.signature_help },
    rename           = { key = '<leader>lr', cmd = vim.lsp.buf.rename },
    code_action      = { key = '<leader>lx', cmd = vim.lsp.buf.code_action },
    diagnostic       = { key = '<leader>ld', cmd = '<Cmd>TroubleToggle workspace_diagnostics<CR>' },
    diagnostic_next  = { key = ']d', cmd = function() vim.diagnostic.goto_next({ float = false }) end },
    diagnostic_prev  = { key = '[d', cmd = function() vim.diagnostic.goto_prev({ float = false }) end },
    declaration      = { key = 'gD', cmd = function() vim.lsp.buf.declaration({ on_list = open_with_qflist }) end },
    format           = { key = '<leader>ff', cmd = function() vim.lsp.buf.format({ async = true }) end },
    document_symbol  = {
        key = '<leader>ls',
        cmd = function() vim.lsp.buf.document_symbol({ on_list = open_with_qflist }) end
    },
    hover            = {
        key = ',k',
        cmd = function()
            local ufo_loaded, ufo = pcall(require, 'ufo')
            if ufo_loaded then
                if ufo.peekFoldedLinesUnderCursor() then return end
            end
            return vim.diagnostic.open_float({ scope = 'cursor' }) or vim.lsp.buf.hover()
        end
    },
    jump_to_context  = { key = '[c', cmd = function() require('treesitter-context').go_to_context() end },
}

-- INFO: Treesitter
keymaps.treesitter = {
    incremental_selection = {
        init_selection = '<Tab>',
        node_incremental = '<Tab>',
        node_decremental = '<S-Tab>',
    },
    textobjects = {
        move = {
            enable = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]/"] = "@comment.outer",
                ["]i"] = "@conditional.outer",
                ["]l"] = "@loop.outer",
                ["]]"] = "@block.outer",
                ["]a"] = "@parameter.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]?"] = "@comment.outer",
                ["]I"] = "@conditional.outer",
                ["]L"] = "@loop.outer",
                ["]}"] = "@block.outer",
                ["]A"] = "@parameter.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[/"] = "@comment.outer,",
                ["[i"] = "@conditional.outer,",
                ["[l"] = "@loop.outer",
                ["[["] = "@block.outer",
                ["[a"] = "@parameter.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[?"] = "@comment.outer,",
                ["[I"] = "@conditional.outer,",
                ["[L"] = "@loop.outer",
                ["[{"] = "@block.outer",
                ["[A"] = "@parameter.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>sa'] = '@parameter.inner',
                ['<leader>sm'] = '@function.outer',
                ['<leader>sc'] = '@class.outer',
            },
            swap_previous = {
                ['<leader>sA'] = '@parameter.inner',
                ['<leader>sM'] = '@function.outer',
                ['<leader>sC'] = '@class.outer',
            },
        },
        peek_definition_code = {
            [',K'] = '@function.outer',
            ['<leader>pc'] = '@class.outer',
        },
    }
}

-- INFO: Lazy keymap
keymaps.lazy = {
    open = '<leader>P',
}

-- INFO: Focus keymap
keymaps.focus = {
    toggle_enable = '<C-space>',
    toggle_size   = 'wt',
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
    stage_hunk   = '<leader>hs',
    reset_hunk   = '<leader>hr',
    preview_hunk = '<leader>hp',
    blame_line   = '<leader>hb',
    toggle_blame = '<leader>hB',
    diff_this    = '<leader>hd',
}

-- INFO: git-conflict keymap
keymaps.gitconflict = {
    toggle_qflist = '<leader>x',
}

-- INFO: Telescope keymap
keymaps.telescope = {
    grep_workspace       = 'gw',
    search_workspace     = '<leader>fw',
    buffers              = '<leader><tab>',
    find_files           = '<leader>fs',
    find_files_hidden    = '<leader>fS',
    resume               = '<leader>;',
    jumplist             = '<leader>ju',
    oldfiles             = '<leader>?',
    file_browse          = '<leader>fb',
    help_tags            = '<leader>?',
    action_buffer_delete = { n = 'd', i = '<m-d>' },
    current_buffer_fuzzy_find = 'fj',
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
    next    = "'",
    prev    = '"',
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

-- INFO: session-manager keymaps
keymaps.session_manager = {
    load   = '<leader>sl',
    save   = '<leader>ss',
    delete = '<leader>sd',
}

-- INFO: Noice keymaps
keymaps.noice = {
    history          = '<leader>M',
    docs_scroll_up   = '<C-u>',
    docs_scroll_down = '<C-d>',
}

-- INFO: flit keymaps
keymaps.flit = {
    forward  = 'f',
    backward = 'F',
    till     = 't',
    backtill = 'T',
    leap     = ',',
}

-- INFO: markdown preview keymap
keymaps.markdown_preview = {
    toggle = '<leader>p',
}

-- INFO: mini.bufremove keymap
keymaps.bufremove = {
    delete = 'wQ',
}

-- INFO: mini.move keymap
keymaps.move = {
    move_up    = '<leader><Up>',
    move_down  = '<leader><Down>',
    move_left  = '<leader><Left>',
    move_right = '<leader><Right>',
}

-- INFO: search-replace keymap
keymaps.search_replace = {
    single_open                   = '<leader>sr',
    multi_open                    = '<leader>sR',
    visual_selection_charwise     = '<C-c>',
    visual_selection_current_word = '<C-r>',
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
}

-- INFO: undotree
keymaps.undotree = {
    open = '<leader>u',
}

return keymaps
