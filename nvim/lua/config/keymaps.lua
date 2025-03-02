local keymaps = {}

keymaps.setup = function()
    -- INFO: move up / down by visible lines with no [count]
    vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
    vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })

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
    -- vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>')
    -- vim.keymap.set('n', '<S-Tab>', '<Cmd>bprev<CR>')
    vim.keymap.set('n', 'wq', '<C-w>q')

    -- INFO: enter command mode with lua prefix
    vim.keymap.set('n', '<leader>:', ':lua ')

    -- INFO: misc. keymap
    vim.keymap.set({ 'n', 'i' }, '<Esc>', '<Cmd>noh<CR><Esc>')
    vim.keymap.set({ 'n', 'i' }, '<C-l>', '<Cmd>noh<CR>')
    vim.keymap.set('n', 'dw', 'vb"_d')      -- delete a word backward
    vim.keymap.set('n', '<leader>d', '"_d') -- delete without yank
    vim.keymap.set('n', 'c', '"_c')
    vim.keymap.set('n', 'x', '"_x')
    vim.keymap.set('x', 'p', '"_c<C-r>+<Esc>') -- replace-paste in insert mode
    vim.keymap.set('i', '<S-Tab>', '<C-d>')    -- de-tab while in insert mode
    vim.keymap.set('n', 'Y', 'y$')             -- Yank line after cursor
    vim.keymap.set('n', 'P', '<cmd>pu<CR>')    -- Paste on new line
    vim.keymap.set('v', '<', '<gv')
    vim.keymap.set('v', '>', '>gv')

    -- INFO: resize window
    -- vim.keymap.set('n', '<C-w><left>', '<C-w><')
    -- vim.keymap.set('n', '<C-w><right>', '<C-w>>')
    -- vim.keymap.set('n', '<C-w><up>', '<C-w>+')
    -- vim.keymap.set('n', '<C-w><down>', '<C-w>-')

    -- INFO: remap jump keys
    vim.keymap.set('n', '<C-j>', '<C-i>')
    vim.keymap.set('n', '<C-k>', '<C-o>')

    -- INFO: quickfix keys
    vim.keymap.set('n', '<leader>q', function() require 'snacks'.picker.qflist() end)
    vim.keymap.set('n', '<leader>Q', '<Cmd>cexpr []<CR>')

    -- INFO: search word under cursor (recursive called `hlslens`)
    vim.keymap.set('n', ']]', '*', { remap = true })
    vim.keymap.set('n', '[[', '#', { remap = true })

    -- INFO: disable ScrollWheelRight and ScrollWheelLeft in normal mode
    vim.keymap.set('n', '<ScrollWheelRight>', '<Nop>', { remap = false, silent = true })
    vim.keymap.set('n', '<ScrollWheelLeft>', '<Nop>', { remap = false, silent = true })

    -- INFO: map Shift+ScrollWheelUp to ScrollWheelRight and Shift+ScrollWheelDown to ScrollWheelLeft in normal mode
    vim.keymap.set('n', '<S-ScrollWheelUp>', '<ScrollWheelRight>', { remap = false, silent = true })
    vim.keymap.set('n', '<S-ScrollWheelDown>', '<ScrollWheelLeft>', { remap = false, silent = true })
end

-- INFO: LSP keymap
keymaps.lsp = {
    definitions      = { key = 'gd', cmd = function() require 'snacks'.picker.lsp_definitions() end },
    type_definitions = { key = 'gt', cmd = function() require 'snacks'.picker.lsp_type_definitions() end },
    reference        = { key = 'gr', cmd = function() require 'snacks'.picker.lsp_references() end },
    implementation   = { key = 'gi', cmd = function() require 'snacks'.picker.lsp_implementations() end },
    signature_help   = { key = 'gs', cmd = vim.lsp.buf.signature_help },
    diagnostic       = { key = '<leader>ld', cmd = function() require 'snacks'.picker.diagnostics() end },
    document_symbol  = { key = '<leader>ls', cmd = function() require 'snacks'.picker.lsp_symbols() end },
    code_action      = { key = '<leader>lx', cmd = vim.lsp.buf.code_action },
    format           = { key = '<leader>ff', cmd = function() vim.lsp.buf.format({ async = true }) end },
    hover            = {
        key = 'K',
        cmd = function()
            return vim.diagnostic.open_float({ scope = 'cursor' }) or vim.lsp.buf.hover()
        end
    },
}

-- INFO: live-rename keymap
keymaps.rename = {
    rename = '<leader>lr',
    rename_clean = '<leader>lR',
}

-- INFO: Treesitter
keymaps.treesitter = {
    incremental_selection = {
        init_selection = '<Tab>',
        node_incremental = '<Tab>',
        node_decremental = '<S-Tab>',
    },
}

-- INFO: Lazy keymap
keymaps.lazy = {
    open = '<leader>P',
}

-- INFO: Jot keymap
keymaps.jot = {
    toggle = '<leader>n',
}

-- INFO: Focus keymap
keymaps.focus = {
    toggle_enable = '<leader><space>',
    toggle_size   = 'wt',
    split_cycle   = '<space>',
    split_left    = 'wh',
    split_right   = 'wl',
    split_up      = 'wk',
    split_down    = 'wj',
}

-- INFO: GitSign keymap
keymaps.gitsigns = {
    next_hunk    = ']c',
    prev_hunk    = '[c',
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

-- INFO: Snacks picker keymap
keymaps.snacks = {
    picker = {
        grep_workspace        = 'gw',
        search_workspace      = '<leader>fw',
        search_buffers        = '<leader>/',
        buffers               = '<leader>\\',
        find_files            = '<leader>fs',
        resume                = '<leader>;',
        jumplist              = '<leader>j',
        oldfiles              = '<leader>fr',
        help_tags             = '<leader>?',
        action_select_all     = '<m-a>',
        action_focus_preview  = '<m-space>',
        action_send_to_qflist = '<C-q>',
        action_scroll_up      = '<C-u>',
        action_scroll_down    = '<C-d>',
    },
    bufdelete = {
        delete = 'wQ',
    },
    terminal = {
        toggle = '<leader>t',
        lazygit = '<leader>g',
        lazygit_file_history = '<leader>G',
    }
}

-- INFO: Oil keymap
keymaps.oil = {
    open_float = '<leader>fb',

}

-- INFO: Todocomments keymap
keymaps.todocomments = {
    toggle    = '<leader>c',
    next_todo = ']t',
    prev_todo = '[t',
}

-- INFO: Marks keymap
keymaps.marks = {
    next   = "'",
    prev   = '"',
    toggle = "m'",
    clear  = 'md',
    list   = '<leader>m',
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

-- INFO: flit keymaps
keymaps.flit = {
    forward  = 'f',
    backward = 'F',
    till     = 't',
    backtill = 'T',
    leap     = 's',
}

-- INFO: mini.move keymap
keymaps.move = {
    move_up    = '<m-k>',
    move_down  = '<m-j>',
    move_left  = '<m-h>',
    move_right = '<m-l>',
}

-- INFO: treesj keymap
keymaps.treesj = {
    toggle = 'J',
}

-- INFO: copilot keymap
keymaps.copilot = {
    next = '<m-]>',
    prev = '<m-[>',
}

-- INFO: codecompanion keymap
keymaps.codecompanion = {
    chat = '<leader>A',
    toggle = '<leader>a',
    inline = 'ga',
}

-- INFO: hbac keymap
keymaps.hbac = {
    toggle_pin = '<leader>p',
}

return keymaps
