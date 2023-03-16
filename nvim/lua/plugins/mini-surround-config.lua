local M = {
    'echasnovski/mini.surround',
    event = { 'BufReadPost', 'BufNewFile' }
}

M.opts = function()
    return {
        mappings = {
            add = 'ca',
            delete = 'cd',
            replace = 'cs',
            highlight = '',
            find = '',
            find_left = '',
            update_n_lines = '',

            suffix_last = 'N',
            suffix_next = 'n',
        },
    }
end

M.config = function(_, opts)
    require('mini.surround').setup(opts)
end

return M
