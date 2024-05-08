local M = {
    -- 'chentoast/marks.nvim',
    'MomePP/marks.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'telescope.nvim' },
}

M.opts = {
    -- whether to map keybinds or not. default true
    default_mappings = false,
    -- which builtin marks to show. default {}
    builtin_marks = {},
    -- whether movements cycle back to the beginning/end of buffer. default true
    cyclic = true,
    -- whether the shada file is updated after modifying uppercase marks. default false
    force_write_shada = false,
    -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
    -- marks, and bookmarks.
    -- can be ither a table with all/none of the keys, or a single number, in which case
    -- the priority applies to all marks.
    -- default 10.
    sign_priority = 15,
    -- disables mark tracking for specific filetypes. default {}
    excluded_filetypes = {
        'toggleterm',
        'lspinfo',
        'terminal',
        'help',
        'TelescopePrompt',
        'TelescopeResults',
    },
    -- extra options modified by `MomePP/marks.nvim`
    marks_sign = '',
}

M.keys = function()
    local marks = require('marks')
    local marks_keymap = require('config.keymaps').marks

    return {
        { marks_keymap.toggle, function() marks.toggle() end },
        { marks_keymap.next,   function() marks.next() end },
        { marks_keymap.prev,   function() marks.prev() end },
        { marks_keymap.clear,  function() marks.delete_buf() end },

        -- NOTE: preview marks in current buffer
        {
            marks_keymap.preview,
            function()
                local mark = marks.mark_state:get_nearest_next_mark()
                if not mark then
                    vim.notify('No marks to preview -  ', vim.log.levels.WARN)
                    return
                end

                local pos = vim.fn.getpos("'" .. mark)
                if pos[2] == 0 then
                    return
                end

                local width = vim.api.nvim_win_get_width(0)
                local height = vim.api.nvim_win_get_height(0)
                vim.api.nvim_open_win(pos[1], true, {
                    relative = 'win',
                    win = 0,
                    width = math.floor(width / 2),
                    height = math.floor(height / 2),
                    col = math.floor(width / 4),
                    row = math.floor(height / 8),
                    border = require('config').defaults.float_border,
                    title = ' Marks previewer '
                })
                vim.keymap.set('n', 'q', ':q<cr>', { buffer = pos[1] })
                vim.cmd('normal! `' .. mark)
                vim.cmd('normal! zz')
            end
        },

        -- NOTE: use quickfix to show all marks
        {
            marks_keymap.list,
            function()
                marks.mark_state:all_to_list('loclist')
                if vim.tbl_isempty(vim.fn.getloclist(0)) then
                    vim.notify('There is no marks -  ', vim.log.levels.WARN)
                    return
                end
                require('telescope.builtin').loclist({
                    prompt_title = 'Marks List',
                    layout_strategy = 'vertical',
                    layout_config = {
                        preview_height = 0.7,
                        prompt_position = 'bottom',
                        width = 0.85,
                        height = 0.8,
                    },
                    sorting_strategy = 'descending',
                })
            end
        },
    }
end

return M
