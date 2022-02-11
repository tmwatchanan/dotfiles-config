#!/bin/bash

# WARN: must have brew installed
brew install wget neovim lazygit git-flow ripgrep neovim-remote gotop fd

# NOTE: add neovim-remote config to default shell config (currently using fish)
# currently handles by using lazygit config -> the downside, it cannot use lazygit outside nvim
# echo -e "export VISUAL=\"nvr --remote-wait + 'set bufhidden=wipe'\"\n" >> ~/.config/fish/config.fish

# -- add edit and open commands for lazygit config if config not exists
lazygit_config=~/Library/Application\ Support/lazygit/config.yml
update_lazygit_config="y"
found_lazygit_config=false
if [ -f "$lazygit_config" ]; then
    found_lazygit_config=true
    read -p "found exist lazygit config file.. overwrite (y) or (n) ? : " update_lazygit_config
fi
if [ $update_lazygit_config = "y" ]; then
    if $found_lazygit_config; then
        rm "$lazygit_config"
    fi
    echo -e "os:\n  editCommand: \"nvim\"\n  openCommand: \"nvr --remote-silent -cc q {{filename}}\"" >> "$lazygit_config"
    echo "added lazygit config !"
else
    echo "skipped lazygit config.."
fi

# -- move nvim config files to local config directory
config_path=~/.config
update_nvim_config="y"
found_nvim_config=false
if [ -d "$config_path/nvim" ]; then
    found_nvim_config=true
    read -p "found exist neovim config files.. overwrite (y) or (n) ? : " update_nvim_config
fi
if [ $update_nvim_config = "y" ]; then
    if $found_nvim_config; then
        rm -rf "$config_path/nvim"
    fi
    cp -r nvim "$config_path"
    echo "added neovim config !"
else
    echo "skipped neovim config.."
fi

