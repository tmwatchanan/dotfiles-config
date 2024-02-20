local M = {
    'folke/zen-mode.nvim',
    dependencies = {
        {
            'folke/twilight.nvim',
            opts = {
                context = 0,
            },
        }
    },
    lazy = false,
}

M.opts = {
    plugins = {
        wezterm = {
            enabled = true,
            font = '+0',
        }
    },
}

M.keys = function()
    local keymap = require('config.keymaps').zen_mode
    return {
        { keymap.toggle, function()
            require('zen-mode').toggle(
                {
                    window = {
                        width = 1,
                    },
                }
            )
        end },
        {
            keymap.toggle_size,
            function()
                require('zen-mode').toggle({
                    window = {
                        width = .85, -- width will be 85% of the editor width
                    },
                    plugins = {
                        wezterm = {
                            font = '+5',
                        }
                    },
                })
            end
        },
    }
end

return M
