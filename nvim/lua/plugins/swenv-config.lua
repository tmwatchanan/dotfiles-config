local M = {
    'AckslD/swenv.nvim',
    ft = { 'python' },
    cond = not vim.g.vscode,
}

M.opts = {
    post_set_venv = function()
        local python_path = require('config.python').get_python_path()
        vim.cmd('PyrightSetPythonPath ' .. python_path)
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
