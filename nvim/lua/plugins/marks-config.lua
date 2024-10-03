local M = {
    -- 'chentoast/marks.nvim',
    'MomePP/marks.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
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
                        preview_height = 0.6,
                        prompt_position = 'bottom',
                        width = 0.7,
                        height = 0.7,
                    },
                    sorting_strategy = 'descending',
                    trim_text = true,
                    initial_mode = 'normal'
                })
            end
        },
    }
end

return M
