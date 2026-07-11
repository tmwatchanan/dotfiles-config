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
            search = ' ',
            session = '󰥿',
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
        bento = {
            pinned = '',
        },
        resession = {
            current = '',
            jumped  = '󰋚',
        }
    },
}

M.init = function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    if not M.did_init then
        M.did_init = true

        require 'config.options'
        require 'zpack-config'

        -- Neovim doesn't ship `#make-range!`, but some of our custom Treesitter
        -- queries rely on it (consumed via `nvim-treesitter.query` helpers).
        -- Register a no-op handler so query execution doesn't error.
        pcall(function()
            vim.treesitter.query.add_directive('make-range!', function() end)
        end)
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
        vim.api.nvim_create_autocmd('UIEnter', {
            group = vim.api.nvim_create_augroup('UserConfig', { clear = true }),
            callback = function()
                vim.schedule(function() load_user_configs() end)
            end,
        })
    else
        load_user_configs()
    end
end

return M
