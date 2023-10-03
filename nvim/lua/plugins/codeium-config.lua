local M = {
    'Exafunction/codeium.vim',
    event = { 'BufEnter' },
}

M.keys = function()
    local codeium_keymap = require('config.keymaps').codeium
    return {
        { codeium_keymap.accept,   function() vim.fn['codeium#Accept']() end,             mode = 'i', { expr = true } },
        { codeium_keymap.previous, function() vim.fn['codeium#CycleCompletions'](-1) end, mode = 'i', { expr = true } },
        { codeium_keymap.next,     function() vim.fn['codeium#CycleCompletions'](1) end,  mode = 'i', { expr = true } },
        { codeium_keymap.clear,    function() vim.fn['codeium#Clear']() end,              mode = 'i', { expr = true } },
    }
end

-- vim.g.codeium_disable_bindings = true
-- vim.g.codeium_no_map_tab = true

return M
