local M = {
    'ggandor/flit.nvim',
    dependencies = {
        'ggandor/leap.nvim',
        opts = {
            special_keys = {
                next_target = '<enter>',
                prev_target = '<s-enter>',
                next_group = '<space>',
                prev_group = '<s-space>',
            }
        }
    },
}

M.opts = {
    labeled_modes = 'nv',
}

M.keys = function()
    local flit_keymap = require('config.keymaps').flit

    local function leap_all_windows()
        require('leap').leap {
            target_windows = vim.tbl_filter(
                function(win)
                    return vim.api.nvim_win_get_config(win).focusable
                end,
                vim.api.nvim_tabpage_list_wins(0)
            )
        }
    end

    return {
        { flit_keymap.forward },
        { flit_keymap.backward },
        { flit_keymap.till },
        { flit_keymap.backtill },
        { flit_keymap.leap,    leap_all_windows },
    }
end

return M
