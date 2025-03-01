local M = {
    enabled = false,
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "plenary.nvim",
    },
}

M.opts = function()
    -- local elixir = require("elixir")
    local elixirls = require("elixir.elixirls")

    return {
        elixirls = {
            enable = true,
            settings = elixirls.settings {
                dialyzerEnabled = false,
                enableTestLenses = false,
            },
        }
    }
end

M.keys = function()
    local keymap = require('config.keymaps').elixir_tools
    return {
        { keymap.elixir_from_pipe,    '<Cmd>ElixirFromPipe<CR>',    buffer = true, noremap = true },
        { keymap.elixir_to_pipe,      '<Cmd>ElixirToPipe<CR>',      buffer = true, noremap = true },
        { keymap.elixir_expand_macro, '<Cmd>ElixirExpandMacro<CR>', mode = 'v',    buffer = true, noremap = true },
    }
end

return M
