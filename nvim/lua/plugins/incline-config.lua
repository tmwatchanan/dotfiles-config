local M = {
    'b0o/incline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-web-devicons' },
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
            local render_icon = {}
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
                local filename_length = vim.fn.fnamemodify(bufname, ":t"):len()
                path_length = math.max(path_length, filename_length + 2)
            end
            local render_path = truncate_utils(
                (bufname ~= '' and vim.fn.fnamemodify(bufname, ':.') or '[No Name]'),
                path_length,
                nil,
                -1
            )

            if vim.bo[props.buf].modified then
                render_icon = { '  ', group = 'InclineModified' }
            else
                local icon, icon_hl = require('nvim-web-devicons').get_icon(
                    vim.fn.fnamemodify(bufname, ':t'),
                    vim.fn.fnamemodify(bufname, ':e'),
                    { default = true }
                )
                render_icon = { ' ', icon, ' ', group = icon_hl }
            end

            return {
                render_icon,
                render_path,
            }
        end,
    }
end

return M
