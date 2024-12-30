local M = {}

M.run_tmux_expr = function(line_num)
    local line = vim.fn.getline(line_num)
    vim.fn.system('tmux ' .. line)
end

return M
