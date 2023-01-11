local M = {
    'Shatur/neovim-session-manager',
    event = 'VimEnter'
}

M.config = function()
    local session_manager = require('session_manager')
    session_manager.setup({
        autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
        autosave_ignore_not_normal = true,
        autosave_only_in_session = true,
    })

    local session_manager_keymaps = require('config.keymaps').session_manager
    vim.keymap.set('n', session_manager_keymaps.load, session_manager.load_session, session_manager_keymaps.opts)
    vim.keymap.set('n', session_manager_keymaps.save, session_manager.save_current_session, session_manager_keymaps.opts)
    vim.keymap.set('n', session_manager_keymaps.delete, session_manager.delete_session, session_manager_keymaps.opts)
end

return M
