-- INFO: checking does nvim runs from `vscode-neovim` or not
-- init options and load plugins
require 'config'.init()

-- loads user config
require 'config'.setup()

if vim.g.vscode then
    -- loads keymap for neovim-vscode
    require 'config.keymaps'
end
