local M = {
    'AckslD/swenv.nvim',
    ft = { 'python' },
    cond = not vim.g.vscode,
}

M.opts = {
    post_set_venv = function()
        -- NOTE: pyrefly resolves the interpreter once at startup (an active
        -- venv/conda env wins), so restart it to re-query the new env
        if next(vim.lsp.get_clients { name = 'pyrefly' }) then
            vim.cmd('LspRestart pyrefly')
        end

        local venv = require('swenv.api').get_current_venv()
        if venv then
            vim.notify(('󰌠 Python interpreter changed (%s)'):format(venv.name), vim.log.levels.INFO)
        end
    end,
}

M.keys = function()
    local keymap = require('config.keymaps').swenv
    return {
        { keymap.pick, function() require('swenv.api').pick_venv() end, mode = 'n' },
    }
end

return M
