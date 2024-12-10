local M = {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    cond = not vim.g.vscode,
}

M.config = function()
    local neocodeium = require('neocodeium')
    neocodeium.setup()
end

M.keys = function()
    local neocodeium = require('neocodeium')
    local codeium_keymap = require('config.keymaps').codeium
    return {
        { codeium_keymap.accept,   function() neocodeium.accept() end,        mode = 'i', expr = true },
        { codeium_keymap.previous, function() neocodeium.cycle(-1) end,       mode = 'i', expr = true },
        { codeium_keymap.next,     function() neocodeium.cycle(1) end,        mode = 'i', expr = true },
        { codeium_keymap.clear,    function() neocodeium.clear() end,         mode = 'i', expr = true },
        { codeium_keymap.chat,     function() vim.cmd('NeoCodeium chat') end, mode = 'n' },
    }
end

return M
