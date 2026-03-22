local gitsigns_module = {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
}

gitsigns_module.opts = {
    gh = true,
    signcolumn = true,
    numhl = true,
    preview_config = {
        border = 'solid',
        row    = 1,
        col    = -1,
    },
    on_attach = function(bufnr)
        local git_keymap = require('config.keymaps').git
        local gitsigns_actions = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', git_keymap.next_hunk,
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ git_keymap.next_hunk, bang = true })
                else
                    gitsigns_actions.nav_hunk('next')
                end
            end)

        map('n', git_keymap.prev_hunk,
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ git_keymap.prev_hunk, bang = true })
                else
                    gitsigns_actions.nav_hunk('prev')
                end
            end)

        map('n', git_keymap.stage_hunk, gitsigns_actions.stage_hunk)
        map('v', git_keymap.stage_hunk,
            function() gitsigns_actions.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)

        map('n', git_keymap.reset_hunk, gitsigns_actions.reset_hunk)
        map('v', git_keymap.reset_hunk,
            function() gitsigns_actions.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)

        map('n', git_keymap.blame_line, function() gitsigns_actions.blame_line { full = true } end)
        map('n', git_keymap.toggle_blame, gitsigns_actions.toggle_current_line_blame)

        map('n', git_keymap.diff_this, gitsigns_actions.diffthis)
    end
}

local inlinediff_module = {
    'cvlmtg/inline-diff.nvim',
    cmd = 'InlineDiff',
}

inlinediff_module.config = function()
    require('inline-diff').setup()

    -- prevent enable() from resetting our highlights on every toggle
    require('inline-diff.highlight').define = function() end

    vim.api.nvim_set_hl(0, 'InlineDiffAdd', { fg = '#78b9b7', bg = '#0e2324' })
    vim.api.nvim_set_hl(0, 'InlineDiffWordAdd', { fg = '#d0eeec', bg = '#1e5554' })
    vim.api.nvim_set_hl(0, 'InlineDiffDelete', { fg = '#be6f90', bg = '#2a161d' })
    vim.api.nvim_set_hl(0, 'InlineDiffWordDel', { fg = '#eaced8', bg = '#532740' })
end

inlinediff_module.keys = function()
    local git_keymap = require('config.keymaps').git

    return {
        { git_keymap.preview_hunk, function() require('inline-diff').toggle() end }
    }
end

return {
    gitsigns_module,
    inlinediff_module
}
