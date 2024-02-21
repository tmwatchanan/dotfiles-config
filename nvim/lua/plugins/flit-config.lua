local M = {
    'ggandor/flit.nvim',
    dependencies = {
        'ggandor/leap.nvim',
        dependencies = 'tpope/vim-repeat',
        opts = {
            highlight_unlabeled_phase_one_targets = true,
        },
    },
}

M.opts = {
    labeled_modes = 'nv',
    multiline = false,
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

local telepath_module = {
    'rasulomaroff/telepath.nvim',
    dependencies = 'ggandor/leap.nvim',
    -- there's no sence in using lazy loading since telepath won't load the main module
    -- until you actually use mappings
    lazy = false,
    config = function()
        require('telepath').use_default_mappings()
    end,
}

return {
    M,
    telepath_module,
}
