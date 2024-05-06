local copilot = {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = 'Copilot',
}

copilot.opts = function()
    local copilot_keymap = require('config.keymaps').copilot

    return {
        suggestion = {
            auto_trigger = false,
            keymap = {
                accept = false,
                dismiss = false,
                next = copilot_keymap.next,
                prev = copilot_keymap.prev,
            }
        },
        panel = { enabled = false },
    }
end

local copilot_lualine = {
    'AndreM222/copilot-lualine',
}

local copilot_chat = {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = { 'copilot.lua', 'plenary.nvim' },
    cmd = 'CopilotChat'
}

copilot_chat.opts = {
    window = {
        layout = 'float',         -- 'vertical', 'horizontal', 'float', 'replace'
        width = 1,                -- fractional width of parent, or absolute width in columns when > 1
        height = 0.4,             -- fractional height of parent, or absolute height in rows when > 1

        -- Options below only apply to floating windows
        relative = 'editor',      -- 'editor', 'win', 'cursor', 'mouse'
        border = 'rounded',       -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = vim.o.lines,        -- row position of the window, default is centered
        col = nil,                -- column position of the window, default is centered
        title = ' Copilot Chat ', -- title of chat window
        footer = nil,             -- footer of chat window
        zindex = 1,               -- determines if window is on top or below other floating windows
    }
}

copilot_chat.config = function(_, opts)
    local chat = require('CopilotChat')
    local select = require('CopilotChat.select')

    -- Use unnamed register for the selection
    -- opts.selection = select.unnamed

    chat.setup(opts)

    vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
        chat.ask(args.args, { selection = select.visual })
    end, { nargs = '*', range = true })

    -- Restore CopilotChatBuffer
    vim.api.nvim_create_user_command('CopilotChatBuffer', function(args)
        chat.ask(args.args, { selection = select.buffer })
    end, { nargs = '*', range = true })
end


copilot_chat.keys = function()
    local copilotchat_keymap = require('config.keymaps').copilot_chat

    return {
        -- Code related commands
        { copilotchat_keymap.explain,        ':CopilotChatExplain<cr>',           mode = { 'n', 'v' },                  desc = 'CopilotChat - Explain code' },
        { copilotchat_keymap.review,         ':CopilotChatReview<cr>',            mode = { 'n', 'v' },                  desc = 'CopilotChat - Review code' },
        { copilotchat_keymap.refactor,       ':CopilotChatOptimize<cr>',          mode = { 'n', 'v' },                  desc = 'CopilotChat - Refactor code' },
        { copilotchat_keymap.docs,           ':CopilotChatDocs<cr>',              mode = { 'n', 'v' },                  desc = 'CopilotChat - Document code' },
        { copilotchat_keymap.fix,            ':CopilotChatFix<cr>',               mode = { 'n', 'v' },                  desc = 'CopilotChat - Fix Diagnostic' },
        { copilotchat_keymap.fix_diagnostic, '<cmd>CopilotChatFixDiagnostic<cr>', desc = 'CopilotChat - Fix Diagnostic' },
        { copilotchat_keymap.test,           '<cmd>CopilotChatTests<cr>',         desc = 'CopilotChat - Generate tests' },

        -- Toggle Copilot Chat Vsplit
        { copilotchat_keymap.toggle,         '<cmd>CopilotChatToggle<cr>',        desc = 'CopilotChat - Toggle' },
        { copilotchat_keymap.toggle,         ':CopilotChatVisual<cr>',            mode = 'x',                           desc = 'CopilotChat - Inline chat' },

        -- Custom input for CopilotChat
        {
            copilotchat_keymap.custom_input,
            function()
                local input = vim.fn.input('Ask Copilot: ')
                if input ~= '' then
                    vim.cmd('CopilotChat ' .. input)
                end
            end,
            desc = 'CopilotChat - Ask input',
        },

        -- Quick chat with Copilot
        {
            copilotchat_keymap.quick_chat,
            function()
                local input = vim.fn.input('Quick Chat: ')
                if input ~= '' then
                    vim.cmd('CopilotChatBuffer ' .. input)
                end
            end,
            desc = 'CopilotChat - Quick chat',
        },

        -- Telescope integrations
        {
            copilotchat_keymap.telescope_prompt,
            function()
                local actions = require('CopilotChat.actions')
                require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
            end,
            desc = 'CopilotChat - Prompt actions',
        },

        -- Generate commit message based on the git diff
        {
            copilotchat_keymap.commit,
            '<cmd>CopilotChatCommit<cr>',
            desc = 'CopilotChat - Generate commit message for all changes',
        },
        {
            copilotchat_keymap.commit_staged,
            '<cmd>CopilotChatCommitStaged<cr>',
            desc = 'CopilotChat - Generate commit message for staged changes',
        },
    }
end

return {
    copilot,
    copilot_lualine,
    copilot_chat,
}
