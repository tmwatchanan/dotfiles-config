local M = {
    'b0o/incline.nvim',
    event = 'VeryLazy',
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
            local full_path = vim.api.nvim_buf_get_name(props.buf)
            local parent_dir = vim.fn.fnamemodify(full_path, ':h:t')
            local filename = vim.fn.fnamemodify(full_path, ':t')

            local is_modified = vim.bo[props.buf].modified
            local errors = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.ERROR })

            return {
                {
                    is_modified and '  ●' or '',
                    group = 'DiagnosticWarn'
                },
                {
                    (errors > 0) and '  E' .. tostring(errors) or '',
                    group = 'DiagnosticError'
                },
                {
                    filename ~= '' and '  ' .. parent_dir .. '/' .. filename or '[No Name]',
                }
            }
        end,
    }
end

return M
