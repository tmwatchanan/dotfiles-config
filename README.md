# MomePP's dotfiles
> Requires `Homebrew` to be installed

> [!TIP]
> Use [GNU Stow](https://www.gnu.org/software/stow/) for managing config files with a symlink farm
> ```sh
> stow . --target="$HOME/.config"
> ```

## Neovim
<img width="1512" alt="image" src="https://github.com/user-attachments/assets/3c865acc-d761-494e-8723-fa3d53fef634">

Runs `neovim-installer.sh` script to install neovim with MomePP's configuration.
``` bash
./neovim-installer.sh
```

#### Keybindings
Most of the keybindings can be modified in [keymaps.lua](nvim/lua/config/keymaps.lua).

#### Plugins
All the installed plugins are listed in [plugins/init.lua](nvim/lua/plugins/init.lua) or [plugins/](nvim/lua/plugins/)

## Fish shell
Requires `fish` and `fisher`(packages manager)

[**`fish`**](https://fishshell.com/)
``` bash
brew install fish   # install fish shell
chsh -s /bin/fish   # set default shell to fish
```

[**`fisher`**](https://github.com/jorgebucaran/fisher)
``` bash
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher   # install fisher
fisher update   # install all listed plugins in `fish_plugins`
```

## tmux
Requires `tmux` and `tmp`(tmux plugins manager)

Already configured with following keybindings
- **Session** - follow by uppercase-letter
- **Window** - follow by Ctrl-key to hold
- **Pane** - follow by lowercase-letter

| **Actions**     | Session                    | Window                             | Pane                       |
| :---        | ---                        | ---                                | ---                        |
| new         | `<prefix>N`                | `<prefix><C-n>`                    | `<prefix>n`                |
| next        | `<prefix>J` or `<prefix>O` | `<prefix><C-j>` or `<prefix><C-o>` | `<prefix>j` or `<prefix>o` |
| previous    | `<prefix>K`                | `<prefix><C-k>`                    | `<prefix>k`                |
| kill        | `<prefix>X`                | `<prefix><C-x>`                    | `<prefix>x`                |

##### Note about tmux terminfo
the correct way to set up tmux terminfo on macOS, we need to compile the description by using `infocmp` from latest ncurses → [Ref. Notes](https://gist.github.com/joshuarli/247018f8617e6715e1e0b5fd2d39bb6c)

> If you are using kitty terminal, needed to set terminfo to `xterm-kitty`. otherwise, the undercurl is not usable.

``` bash
# install latest ncurses
brew install ncurses

# export tmux terminfo
/opt/homebrew/Cellar/ncurses/<version>/bin/infocmp tmux-256color > ~/tmux-256color.info

# compiling terminfo description to system database
sudo tic -xe tmux-256color ~/tmux-256color.info
```

## skhd
- Using `skhd` with `fish` shell can cause some slowness issue. See [Long Delay before Action #42](https://github.com/koekeishiya/skhd/issues/42) for specifying the `SHELL` environment variable to be `/bin/sh` instead. Then, you'll have a much snappier reactions.

## bat
To install a custom theme, use the following commands:
```sh
bat cache --build

# to check the available themes
bat --list-themes
```
