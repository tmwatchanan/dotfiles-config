local M = {
    'Exafunction/codeium.vim',
    event = { 'BufEnter' },
    -- init = function()
    --     vim.g.codeium_tab_fallback = "<Tab>"
    --     vim.g.codeium_disable_bindings = true
    --     vim.g.codeium_no_map_tab = true
    -- end,
}

M.keys = function()
    local codeium_keymap = require('config.keymaps').codeium
    return {
        { codeium_keymap.accept,   function() vim.api.nvim_input(vim.fn['codeium#Accept']()) end, mode = 'i', expr = true },
        { codeium_keymap.previous, function() vim.fn['codeium#CycleCompletions'](-1) end,         mode = 'i', expr = true },
        { codeium_keymap.next,     function() vim.fn['codeium#CycleCompletions'](1) end,          mode = 'i', expr = true },
        { codeium_keymap.clear,    function() vim.fn['codeium#Clear']() end,                      mode = 'i', expr = true },
        { codeium_keymap.chat,     function() vim.fn['codeium#Chat']() end,                       mode = 'n' },
    }
end

return M
