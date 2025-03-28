#!/bin/bash

# WARN: must have brew installed
brew install wget luarocks neovim lazygit git-flow-avh git-delta ripgrep fd jq eza

# INFO: -- move nvim config files to local config directory
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

# INFO: -- add edit and open commands for lazygit config if config not exists
update_lazygit_config="y"
found_lazygit_config=false
if [ -d "$config_path/lazygit" ]; then
    found_lazygit_config=true
    read -p "found exist lazygit config.. overwrite (y) or (n) ? : " update_lazygit_config
fi
if [ $update_lazygit_config = "y" ]; then
    if $found_lazygit_config; then
        rm -rf "$config_path/lazygit"
    fi
    cp -r lazygit "$config_path"
    echo "added lazygit config !"
else
    echo "skipped lazygit config.."
fi

# INFO: -- symlink gitconfig file
gitconfig=~/.gitconfig
update_gitconfig="y"
found_gitconfig=false
if [[ -f "$gitconfig" || -L "$gitconfig" ]]; then
    found_gitconfig=true
    read -p "found exist gitconfig file.. overwrite (y) or (n) ? : " update_gitconfig
fi
if [ $update_gitconfig = "y" ]; then
    if $found_gitconfig; then
        rm "$gitconfig" # remove old symlink or old config file
    fi
    ln -s "${config_path}/.gitconfig" "$gitconfig"
    echo "update gitconfig !"
else
    echo "skipped gitconfig.."
fi
