local M = {
    'serhez/bento.nvim',
    event = 'VeryLazy',
    cond = not vim.g.vscode,
}

M.opts = {
    max_open_buffers = 20,
    -- NOTE: locked buffers sort to the top, so menu positions 1-5 are stable pinned slots
    locked_first = true,
    ui = {
        floating = {
            max_rendered_buffers = 10,
        }
    },
    lock_char = require('config').defaults.icons.bento.pinned,
}

M.config = function(_, opts)
    require('bento').setup(opts)

    -- NOTE: position jump inside the expanded menu: `;` then 1-5 selects the
    -- buffer at that list position. Bento binds its labels as temporary
    -- global maps only while the menu is expanded; mirror that lifecycle
    -- for the number keys by wrapping the menu state transitions.
    local ui = require('bento.ui')

    -- NOTE: an expanded menu is detected through bento's own temporary label
    -- maps (desc "Bento: Select buffer N") since its menu buffer carries no
    -- identifying marker
    local function menu_is_expanded()
        for _, map in ipairs(vim.api.nvim_get_keymap('n')) do
            if map.desc and map.desc:find('Bento: Select buffer', 1, true) == 1 then
                return true
            end
        end
        return false
    end

    local bound = false
    local function unbind_position_keys()
        if not bound then
            return
        end
        bound = false
        for i = 1, 5 do
            pcall(vim.keymap.del, 'n', tostring(i))
        end
    end
    local function bind_position_keys()
        if bound or not menu_is_expanded() then
            return
        end
        bound = true
        for i = 1, 5 do
            vim.keymap.set('n', tostring(i), function()
                require('bento.ui').select_buffer(i)
                unbind_position_keys()
            end, { silent = true, desc = 'Bento slot ' .. i })
        end
    end

    local expand_menu, collapse_menu, close_menu = ui.expand_menu, ui.collapse_menu, ui.close_menu
    ui.expand_menu = function(...)
        expand_menu(...)
        bind_position_keys()
    end
    ui.collapse_menu = function(...)
        collapse_menu(...)
        unbind_position_keys()
    end
    ui.close_menu = function(...)
        close_menu(...)
        unbind_position_keys()
    end
end

M.keys = function()
    local bento_keymap = require('config.keymaps').bento

    return {
        { bento_keymap.toggle_lock, function() require('bento').toggle_lock() end },
    }
end

return M
