-- herd.nvim — nvim is the host, herdr is the backend daemon. CLI agents run in
-- nvim floating terminals via `herdr agent attach`. https://github.com/MomePP/herd.nvim
--
-- INFO: gated on the `herdr` binary being installed (NOT on HERDR_PANE_ID). In the
-- nvim-host model nvim no longer needs to live inside a herdr pane — herdr just needs
-- its server/daemon running. The plugin's own ensure_server() warns if it isn't.
return {
    'MomePP/herd.nvim',
    dev = true,                -- use local ~/Developer/nvim-plugins/herd.nvim (currently on feat/nvim-host-herdr-backend)
    cond = function() return vim.fn.executable('herdr') == 1 end,
    event = 'VeryLazy',
    opts = {
        -- Dedicated herdr workspace that hosts spawned agents (off your project
        -- tabs). Labelled "herd.nvim" so the sidebar reads "herd.nvim · <project>",
        -- signalling the agent was spawned from nvim.
        workspace = 'herd.nvim',
        -- Keybinds mirror the old sidekick.nvim scheme. herd is fully nvim-side
        -- (it never touches herdr's own keybinds), so the <leader><Tab> compromise
        -- is unnecessary — reuse the familiar, now-freed sidekick keys.
        -- Hide ≠ kill; agents persist in herdr.
        keys = {
            toggle    = '<leader>s', -- normal: toggle this project's agent (count = slot)
            send      = '<leader>s', -- visual: send the selection to the active agent
            hide      = '<leader>s', -- terminal: hide the float from inside
            select    = '<leader>S', -- normal: grouped agent picker (switch / spawn)
            dashboard = false,       -- focus-herd-workspace; unmapped (use :Herd dashboard)
        },
        -- INFO: fullscreen + transparent float, mirroring the sidekick.nvim styling:
        -- width/height 1 = fullscreen; invisible 8-element border reserves only the
        -- bottom row for the footer; winblend 0 opts out of the global 5; transparency
        -- comes from winhighlight → SnacksTerminal* (which inherit the transparent Normal).
        win = {
            width        = 1,
            height       = 1,
            border       = { '', '', '', '', ' ', ' ', ' ', '' },
            winblend     = 0,
            footer       = true,
            winhighlight =
            'Normal:SnacksTerminalNormal,NormalNC:SnacksTerminalNormal,FloatBorder:SnacksTerminalBorder,FloatFooter:SnacksTerminalFooter',
        },
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
