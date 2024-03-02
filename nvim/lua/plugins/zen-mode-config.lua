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

local function set_twilight_context(context)
    require('twilight.config').options.context = context
end

local function toggle_twilight(context)
    context = context or 0
    set_twilight_context(context)
    require('twilight').toggle()
end

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
                        width = .95, -- width will be 95% of the editor width
                    },
                    plugins = {
                        wezterm = {
                            font = '+3',
                        }
                    },
                })
            end
        },
        { keymap.twilight_current_line, function() toggle_twilight(0) end },
        { keymap.twilight_context,      function() toggle_twilight(2) end },
    }
end

return M
