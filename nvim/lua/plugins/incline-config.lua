local M = {
    'b0o/incline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'mini.icons' },
}

M.opts = function()
    local truncate_utils = require('plenary.strings').truncate

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
            local line_number = vim.fn.line('w0', props.win) - 1
            local first_line_length = vim.api.nvim_buf_get_lines(props.buf, line_number, line_number + 1, false)[1]:len()
            if props.focused then
                local treesitter_context_status, treesitter_context = pcall(require, 'treesitter-context.context')
                if treesitter_context_status then
                    local context, _ = treesitter_context.get(props.buf, props.win)
                    if context and #context > 0 then
                        first_line_length = vim.fn.getline(context[1][1] + 1):len()
                    end
                end
            end
            local bufname = vim.api.nvim_buf_get_name(props.buf)
            local win_width = vim.api.nvim_win_get_width(props.win)
            local path_length = win_width - first_line_length - 10
            if not props.focused then
                local filename_length = filename:len()
                path_length = math.max(path_length, filename_length + 2)
            end

            local ext = vim.fn.fnamemodify(bufname, ':e')
            local is_file = type(filename) == 'string'
            local category = is_file and 'file' or 'extension'
            local icon, icon_hl, _ = require('mini.icons').get(category, is_file and filename or ext)

            local render_icon = { ' ', icon, ' ', group = icon_hl }
            local render_path = truncate_utils(
                (bufname ~= '' and vim.fn.fnamemodify(bufname, ':.') or '[No Name]'),
                path_length,
                nil,
                -1
            )
            return {
                { render_icon },
                { render_path, gui = 'bold', guifg = vim.bo[props.buf].modified and '#ffaa00' or nil },
            }
        end,
    }
end

return M
