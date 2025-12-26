local M = {
    'stevearc/resession.nvim',
    lazy = false,
}

M.opts = function()
    return {
        extensions = { hbac = {} }
    }
end

M.config = function(_, opts)
    local resession = require('resession')

    resession.setup(opts)

    -- NOTE: load a dir-specific session when open nvim, save when exit.
    vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
            if vim.fn.argc(-1) == 0 then
                resession.load(vim.fn.getcwd(), { silence_errors = true })
            end
        end,
        nested = true,
    })
    vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
            -- NOTE: save only exist session
            local files = require('resession.files')
            local current_session = string.format('%s', vim.fn.getcwd():gsub(files.sep, '_'):gsub(':', '_'))

            for _, session_name in ipairs(resession.list()) do
                if session_name == current_session then
                    resession.save(vim.fn.getcwd(), { notify = true })
                    return
                end
            end
        end,
    })
end

M.keys = function()
    local resession_keymap = require('config.keymaps').resession

    return {
        { resession_keymap.save,   function() require('resession').save(vim.fn.getcwd()) end },
        { resession_keymap.delete, function() require('resession').delete() end },
    }
end

return M
