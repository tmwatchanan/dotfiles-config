local M = {
    'ThePrimeagen/harpoon',
    event = 'UIEnter',
}

M.keys = function()
    local keymap = require('config.keymaps').harpoon
    return {
        { keymap.toggle_quick_menu, function() require('harpoon.ui').toggle_quick_menu() end },
        { keymap.add_file,          function() require('harpoon.mark').add_file() end },
        { keymap.nav_next,          function() require('harpoon.ui').nav_next() end },
        { keymap.nav_prev,          function() require('harpoon.ui').nav_prev() end },
        { keymap.nav_file_1,        function() require('harpoon.ui').nav_file(1) end },
        { keymap.nav_file_2,        function() require('harpoon.ui').nav_file(2) end },
        { keymap.nav_file_3,        function() require('harpoon.ui').nav_file(3) end },
        { keymap.nav_file_4,        function() require('harpoon.ui').nav_file(4) end },
        { keymap.nav_file_5,        function() require('harpoon.ui').nav_file(5) end },
        { keymap.go_to_terminal_1,  function() require('harpoon.tmux').gotoTerminal(1) end },
        { keymap.go_to_terminal_2,  function() require('harpoon.tmux').gotoTerminal(2) end },
        { keymap.go_to_terminal_3,  function() require('harpoon.tmux').gotoTerminal(3) end },
    }
end

return M
