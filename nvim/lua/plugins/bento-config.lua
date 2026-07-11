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
    -- buffer at that list position, with a `(n)` hint rendered in the left
    -- padding of the first five rows. Bento binds its labels as temporary
    -- global maps only while the menu is expanded; mirror that lifecycle by
    -- wrapping the menu state transitions.
    local ui = require('bento.ui')
    local ns = vim.api.nvim_create_namespace('bento_position_hints')
    local HINTS = 5
    local HINT_WIDTH = 4 -- strwidth of '(n) '

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

    -- NOTE: the menu float is recognized by the winhighlight bento sets on it
    local function find_menu()
        local expected = 'Normal:' .. require('bento').get_config().highlights.window_bg
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local cfg = vim.api.nvim_win_get_config(win)
            if cfg.relative ~= '' and not cfg.focusable then
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == 'nofile' and vim.wo[win].winhighlight == expected then
                    return win, buf
                end
            end
        end
    end

    local bound = false
    local function unbind_position_keys()
        if not bound then
            return
        end
        bound = false
        for i = 1, HINTS do
            pcall(vim.keymap.del, 'n', tostring(i))
        end
    end
    local function bind_position_keys()
        if bound then
            return
        end
        bound = true
        for i = 1, HINTS do
            vim.keymap.set('n', tostring(i), function()
                require('bento.ui').select_buffer(i)
                unbind_position_keys()
            end, { silent = true, desc = 'Bento slot ' .. i })
        end
    end

    -- NOTE: select_buffer(n) targets absolute list positions, so the hints
    -- are only valid (and shown) on the first page
    local page = 1
    local function decorate()
        local win, buf = find_menu()
        if not buf then
            return
        end
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        if page ~= 1 then
            return
        end
        local lines = vim.api.nvim_buf_line_count(buf)
        for i = 1, lines do
            local hint = i <= HINTS and ('(%d) '):format(i) or string.rep(' ', HINT_WIDTH)
            vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
                virt_text = { { hint, i <= HINTS and 'Comment' or 'Normal' } },
                virt_text_pos = 'inline',
            })
        end
        -- widen the float for the hint column, keeping the right edge fixed
        local cfg = vim.api.nvim_win_get_config(win)
        pcall(vim.api.nvim_win_set_config, win, {
            relative = 'editor',
            width = cfg.width + HINT_WIDTH,
            height = cfg.height,
            row = cfg.row,
            col = math.max(cfg.col - HINT_WIDTH, 0),
        })
    end

    local function sync()
        if menu_is_expanded() then
            bind_position_keys()
            decorate()
        else
            unbind_position_keys()
        end
    end

    local page_hooks = {
        expand_menu = function() page = 1 end,
        collapse_menu = function() page = 1 end,
        close_menu = function() page = 1 end,
        next_page = function() page = page + 1 end,
        prev_page = function() page = math.max(page - 1, 1) end,
    }
    local transitions = {
        'expand_menu', 'collapse_menu', 'close_menu', 'refresh_menu',
        'set_action_mode', 'handle_main_keymap', 'next_page', 'prev_page',
    }
    for _, name in ipairs(transitions) do
        local orig, on_call = ui[name], page_hooks[name]
        ui[name] = function(...)
            orig(...)
            if on_call then
                on_call()
            end
            sync()
        end
    end
end

M.keys = function()
    local bento_keymap = require('config.keymaps').bento

    return {
        { bento_keymap.toggle_lock, function() require('bento').toggle_lock() end },
    }
end

return M
