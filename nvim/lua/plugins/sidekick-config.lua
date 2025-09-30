local M = {
    'folke/sidekick.nvim'
}

M.opts = {
    cli = {
        mux = {
            backend = 'tmux',
            enabled = true,
        },
    }
}

M.keys = function()
    local sidekick_keymap = require('config.keymaps').sidekick

    return {
        {
            sidekick_keymap.apply_nes,
            function()
                -- if there is a next edit, jump to it, otherwise apply it if any
                if require('sidekick').nes_jump_or_apply() then
                    return -- jumped or applied
                end
                -- fall back to normal tab
                return '<tab>'
            end,
            mode = { 'i', 'n' },
            expr = true,
            desc = 'Goto/Apply Next Edit Suggestion',
        },
        {
            sidekick_keymap.toggle,
            function()
                require('sidekick.cli').toggle({ name = 'copilot', focus = true })
            end,
            desc = 'Sidekick Toggle CLI',
            mode = { 'n', 'v' },
        },
        {
            sidekick_keymap.prompt,
            function()
                require('sidekick.cli').select_prompt()
            end,
            desc = 'Sidekick Prompt Picker',
            mode = { 'n', 'v' },
        },
    }
end

return M
