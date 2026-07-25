local M = {
    'laytan/cloak.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
}

M.opts = {
    patterns = {
        {
            file_pattern = { '.env*', '*.env', '.netrc' },
            cloak_pattern = {
                -- NOTE: `.env*`
                -- '=.+',
                { '([#]?[ ]?)(.*KEY.*)=(.+)',      replace = '%1%2=' },
                { '([#]?[ ]?)(.*SECRET.*)=(.+)',   replace = '%1%2=' },
                { '([#]?[ ]?)(.*PASSWORD.*)=(.+)', replace = '%1%2=' },

                -- NOTE: `.netrc`
                { '(password) (.+)', replace = '%1 ' },
            },
        },
        {
            -- rclone keys are lowercase and padded (`key = value`); cloak.nvim
            -- matches with Lua patterns, so they need their own entry
            file_pattern = 'rclone.conf',
            cloak_pattern = {
                { '(.*key.*=%s*)(.+)',    replace = '%1' },
                { '(.*secret.*=%s*)(.+)', replace = '%1' },
                { '(.*pass.*=%s*)(.+)',   replace = '%1' },
                { '(.*token.*=%s*)(.+)',  replace = '%1' },
                { '(.*cred.*=%s*)(.+)',   replace = '%1' },
            },
        },
    },
}

M.keys = function()
    local cloak_keymap = require('config.keymaps').cloak

    return {
        { cloak_keymap.toggle,       '<Cmd>CloakToggle<CR>' },
        { cloak_keymap.preview_line, '<Cmd>CloakPreviewLine<CR>' },
    }
end


return M
