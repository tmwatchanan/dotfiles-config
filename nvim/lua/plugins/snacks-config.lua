local M = {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
}

M.opts = {
    bigfile = {
        enabled = true,
        size = 1.5 * 1024 * 1024, -- MB
        ---@param ctx {buf: number, ft:string}
        setup = function(ctx)
            vim.cmd([[NoMatchParen]])
            require('snacks').util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
            vim.b.minianimate_disable = true
            vim.schedule(function()
                vim.bo[ctx.buf].syntax = ctx.ft
            end)
        end,
    },
    gitbrowse = {
        url_patterns = {
            ['git.wndv.co'] = {
                branch = '/-/tree/{branch}',
                file = '/-/blob/{branch}/{file}#L{line_start}-L{line_end}',
                commit = '/-/commit/{commit}',
            },
        },
    },
}

M.keys = function()
    local snacks_keymap = require('config.keymaps').snacks

    return {
        { snacks_keymap.gitbrowse,      function() Snacks.gitbrowse() end,      desc = 'Snacks: Git Browse',    mode = { 'n', 'v' } },
        { snacks_keymap.git_blame_line, function() Snacks.git.blame_line() end, desc = 'Snacks: Git Blame Line' },
    }
end

return M
