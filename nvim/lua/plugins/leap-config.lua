local M = {
    'ggandor/leap.nvim',
    opts = true,
}

M.keys = function()
    local leap_keymap = require('config.keymaps').leap

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

    local function leap_one_char(user_key)
        local leap = require('leap').leap
        local with_traversal_keys = require('leap.user').with_traversal_keys

        local function as_ft(key_specific_args)
            local common_args = {
                inputlen = 1,
                inclusive_op = true,
                opts = {
                    labels = {}, -- force autojump
                    safe_labels = vim.fn.mode(1):match('o') and {} or nil,
                    case_sensitive = true,
                    equivalence_classes = {},
                },
            }
            return vim.tbl_deep_extend('keep', common_args, key_specific_args)
        end

        local clever_f = with_traversal_keys('f', 'F')
        local clever_t = with_traversal_keys('t', 'T')

        if user_key == leap_keymap.forward then
            leap(as_ft({ opts = clever_f }))
        elseif user_key == leap_keymap.backward then
            leap(as_ft({ opts = clever_f, backward = true }))
        elseif user_key == leap_keymap.till then
            leap(as_ft({ opts = clever_t, offset = -1 }))
        elseif user_key == leap_keymap.backtill then
            leap(as_ft({ opts = clever_t, backward = true, offset = 1 }))
        end
    end

    return {
        { leap_keymap.forward,  function() leap_one_char(leap_keymap.forward) end },
        { leap_keymap.backward, function() leap_one_char(leap_keymap.backward) end },
        { leap_keymap.till,     function() leap_one_char(leap_keymap.till) end },
        { leap_keymap.backtill, function() leap_one_char(leap_keymap.backtill) end },
        { leap_keymap.leap,     leap_all_windows },
    }
end

return M
