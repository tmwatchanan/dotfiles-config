local M = {
    'b0o/incline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'mini.icons' },
}

M.opts = function()
    return {
        debounce_threshold = {
            rising = 50,
            falling = 100
        },
        window = {
            padding = { left = 0, right = 1 },
            margin = { horizontal = 0, vertical = 1 },
            zindex = 10,
        },
        render = function(props)
            local bufname = vim.api.nvim_buf_get_name(props.buf)
            local filename = vim.fn.fnamemodify(bufname, ':t')

            local ext = vim.fn.fnamemodify(bufname, ':e')
            local is_file = type(filename) == 'string'
            local category = is_file and 'file' or 'extension'
            local icon, _, _ = require('mini.icons').get(category, is_file and filename or ext)
            local is_modified = vim.bo[props.buf].modified

            return {
                {
                    ' ',
                    icon,
                    ' ',
                    filename ~= '' and filename or '[No Name]',
                    group = is_modified and 'DiagnosticWarn' or nil
                }
            }
        end,
    }
end

return M
