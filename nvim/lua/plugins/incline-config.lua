local M = {
    'b0o/incline.nvim',
    event = 'VeryLazy',
    cond = not vim.g.vscode,
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
            local line_number = vim.fn.line('w0', props.win) - 1
            local first_line_length = vim.api.nvim_buf_get_lines(props.buf, line_number, line_number + 1, false)[1]:len()
            if props.focused then
                local treesitter_context_status, treesitter_context = pcall(require, 'treesitter-context.context')
                if treesitter_context_status then
                    local context, _ = treesitter_context.get(props.win)
                    if context and #context > 0 then
                        first_line_length = vim.fn.getline(context[1][1] + 1):len()
                    end
                end
            end
            local win_width = vim.api.nvim_win_get_width(props.win)
            local path_length = win_width - first_line_length - 10
            if not props.focused then
                local filename_length = filename:len()
                path_length = math.max(path_length, filename_length + 2)
            end

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
