local M = {
    'ggandor/leap.nvim',
    opts = true,
}

M.keys = function()
    local leap_keymap = require('config.keymaps').leap

    local function leap_all_windows()
        require('leap').leap {
            target_windows = vim.tbl_filter(
                function(win) return vim.api.nvim_win_get_config(win).focusable end,
                vim.api.nvim_tabpage_list_wins(0)
            )
        }
    end

    local function leap_one_char(user_key)
        local leap_user = require('leap.user')
        local clever_f = leap_user.with_traversal_keys(leap_keymap.forward, leap_keymap.backward)
        local clever_t = leap_user.with_traversal_keys(leap_keymap.till, leap_keymap.backtill)

        -- Lookup table for key configurations
        local key_configs = {
            [leap_keymap.forward] = { opts = clever_f },
            [leap_keymap.backward] = { opts = clever_f, backward = true },
            [leap_keymap.till] = { opts = clever_t, offset = -1 },
            [leap_keymap.backtill] = { opts = clever_t, backward = true, offset = 1 },
        }

        local config = key_configs[user_key]
        if not config then return end

        -- Cache mode check result
        local is_operator_pending = vim.fn.mode(1):match('o')

        -- Build leap arguments directly
        local leap_args = vim.tbl_deep_extend('keep', config, {
            inputlen = 1,
            inclusive_op = true,
            opts = {
                labels = {}, -- force autojump
                safe_labels = is_operator_pending and {} or nil,
                case_sensitive = true,
                equivalence_classes = {},
            },
        })

        require('leap').leap(leap_args)
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
