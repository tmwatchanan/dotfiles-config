local M = {
    'jam1015/vim-slime', -- 'jpalardy/vim-slime'
    branch = 'validate_config',
    ft = { 'julia' },
}

M.init = function()
    -- vim.g.slime_no_mappings = true
    vim.g.slime_target = 'tmux'
    vim.g.slime_paste_file = '$HOME/.slime_paste'
end

M.config = function()
    vim.g.slime_dont_ask_default = 1
    vim.g.slim_default_config = { socket_name = 'default', target_pane = ':.1' }
    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = true
    vim.g.slime_menu_config = false
end

return M
