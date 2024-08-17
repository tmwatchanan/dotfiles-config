local M = {
    'laytan/cloak.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
}

M.opts =
{
    patterns = {
        {
            file_pattern = { '.env*' },
            cloak_pattern = {
                -- '=.+',
                { '(.*KEY.*)=(.+)',      replace = '%1=' },
                { '(.*SECRET.*)=(.+)',   replace = '%1=' },
                { '(.*PASSWORD.*)=(.+)', replace = '%1=' },
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
