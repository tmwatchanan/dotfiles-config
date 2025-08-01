local M = {
    did_init = false
}

M.defaults = {
    icons = {
        git = {
            added = ' ',
            modified = ' ',
            removed = ' ',
        },
        lualine = {
            git = '󰘬',
            session = '󰥿',
            pinned = '',
            location = ' ',
            lsp = ' ',
            navic_separator = '  ',
        },
        dap = {
            breakpoint = '',
            breakpoint_condition = '',
            breakpoint_rejected = '',
            log_point = '',
            stopped = '',
        },
    },
}

M.init = function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    if not M.did_init then
        M.did_init = true

        require 'config.options'
        require 'lazy-config'
    end
end

M.setup = function()
    local function load_user_configs()
        require 'config.autocommands'
        require 'config.filetypes'
        require 'config.keymaps'.setup()
        if vim.g.vscode then
            require 'config.keymaps' -- load keymap for vscode-neovim
        end
    end

    if vim.fn.argc(-1) == 0 then
        -- setup autocommands to load user opts with VeryLazy event
        vim.api.nvim_create_autocmd('User', {
            group = vim.api.nvim_create_augroup('UserConfig', { clear = true }),
            pattern = 'VeryLazy',
            callback = function()
                load_user_configs()
            end,
        })
    else
        load_user_configs()
    end
end

return M
