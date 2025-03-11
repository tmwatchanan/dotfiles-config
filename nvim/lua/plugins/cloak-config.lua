local M = {
    'laytan/cloak.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
}

M.opts = {
    patterns = {
        {
            file_pattern = { '.env*', '.netrc' },
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
