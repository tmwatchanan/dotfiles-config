local M = {
    'AckslD/swenv.nvim',
    ft = { 'python' },
}

M.opts = {
    post_set_venv = function()
        local python_path = require('config.python').get_python_path()
        vim.cmd('PyrightSetPythonPath ' .. python_path)
    end,
}

M.keys = function()
    local keymap = require('config.keymaps').swenv
    return {
        { keymap.pick, function() require('swenv.api').pick_venv() end, mode = 'n' },
    }
end

return M
