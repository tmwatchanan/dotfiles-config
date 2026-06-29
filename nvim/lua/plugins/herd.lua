-- herd.nvim — Path B agent control (herdr as host): nvim in one herdr pane, CLI
-- agents in siblings. https://github.com/MomePP/herd.nvim
--
-- INFO: gated on HERDR_PANE_ID so it ONLY activates when nvim is launched inside a
-- herdr pane. Outside herdr (normal sessions) it stays disabled, so its keymaps
-- (<leader>s / <leader>S, shared with sidekick.nvim) never clash with sidekick.
-- Inside herdr you are in the Path B world; herd owns those keys there.
return {
    'MomePP/herd.nvim',
    dev = true,                -- use local ~/Developer/nvim-plugins/herd.nvim (fallback: GitHub)
    cond = function() return vim.env.HERDR_PANE_ID ~= nil end,
    event = 'VeryLazy',
    opts = {
        -- herd.nvim = pure spawner: only <leader><Tab> picks/spawns a CLI tool.
        -- Navigation (nvim <-> agent) is herdr-native directional focus: Ctrl-a h / l.
        keys = { toggle = false, send = false, select = '<leader><Tab>' },
        tools = {
            claude   = { cmd = { 'claude' } },
            opencode = {
                cmd = { 'opencode', '--continue' },
                env = {
                    OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = 'true',
                    OPENCODE_EXPERIMENTAL_LSP_TOOL = 'true',
                },
            },
            omp      = { cmd = { 'omp', '--continue' } },
        },
    },
}
