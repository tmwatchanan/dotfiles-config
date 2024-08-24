local M = {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'plenary.nvim' },
}

M.keys = function()
    local harpoon = require('harpoon')
    local keymap = require('config.keymaps').harpoon
    return {
        { keymap.toggle_quick_menu, function() harpoon.ui:toggle_quick_menu(harpoon:list()) end },
        { keymap.add_file,          function() harpoon:list():add() end },
        { keymap.nav_next,          function() harpoon:list():next() end },
        { keymap.nav_prev,          function() harpoon:list():prev() end },
        { keymap.nav_file_1,        function() harpoon:list():select(1) end },
        { keymap.nav_file_2,        function() harpoon:list():select(2) end },
        { keymap.nav_file_3,        function() harpoon:list():select(3) end },
        { keymap.nav_file_4,        function() harpoon:list():select(4) end },
        { keymap.nav_file_5,        function() harpoon:list():select(5) end },
    }
end

return M
