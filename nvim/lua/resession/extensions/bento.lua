--- Persist bento.nvim lock state and buffer metrics in resession sessions.
--- Bento serializes both into path-keyed globals (vim.g.BentoLockedBuffers,
--- vim.g.BentoBufferMetrics) for :mksession support; resession doesn't save
--- globals, so this extension carries them in the session file instead.
local M = {}

M.on_save = function()
    return {
        locked = vim.g.BentoLockedBuffers,
        metrics = vim.g.BentoBufferMetrics,
    }
end

M.on_post_load = function(data)
    vim.g.BentoLockedBuffers = data.locked
    vim.g.BentoBufferMetrics = data.metrics
    -- NOTE: bento restores from the globals in setup(), which covers the
    -- startup autoload (bento loads on VeryLazy, after VimEnter); when bento
    -- is already running (project jump), re-fire its own restore handler.
    -- Deferred: at on_post_load time the restored buffers are not yet
    -- resolvable by name, so an immediate fire maps no locks.
    if package.loaded['bento'] then
        vim.schedule(function()
            pcall(vim.api.nvim_exec_autocmds, 'SessionLoadPost', { group = 'BentoRefresh' })
        end)
    end
end

return M
