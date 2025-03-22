local M = {}

-- INFO: append the repeated trailing '-' not exceeding 80 columns
M.append_repeated_trailing_characters = function(character)
    local colorcolumn = 80
    local current_line = vim.api.nvim_get_current_line()
    local current_line_length = current_line:len()

    -- INFO: remove the pattern if exists
    local pattern = '%s[' .. character .. ']+$'
    if current_line:match(pattern) then
        local current_line_stripped = current_line:gsub(pattern, '')
        vim.api.nvim_set_current_line(current_line_stripped)
        return
    end

    -- INFO: append '-' if the line length is not exceeding colorcolumn
    if current_line_length < colorcolumn - 1 then
        local stripping_pattern = '(.' .. character .. ')%s*$'
        local current_line_stripped = current_line:gsub(stripping_pattern, '%1')
        local appending_text = string.rep(character, colorcolumn - current_line_length - 1)
        vim.api.nvim_set_current_line(('%s %s'):format(current_line_stripped, appending_text))
    end
end

M.apply_function = function(fn)
    return function()
        local mode = vim.fn.mode()
        if mode == 'n' then
            fn('.')
        elseif mode == 'V' then
            vim.cmd([[ execute "normal! \<ESC>" ]])
            local start_line = vim.fn.getpos("'<")[2]
            local end_line = vim.fn.getpos("'>")[2]

            for line_num = start_line, end_line do
                fn(line_num)
            end
        end
    end
end

M.run_tmux_expr = function(line_num)
    local line = vim.fn.getline(line_num)
    vim.fn.system('tmux ' .. line)
end

M.GetHighlightGroupUnderCursor = function()
    local result = vim.treesitter.get_captures_at_cursor(0)
    print(vim.inspect(result))
end

return M
