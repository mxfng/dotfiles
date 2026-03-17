# Max's dotfiles

My personal dotfiles for macOS and Linux.

- fish shell
- Neovim
- WezTerm
- tmux
- Starship prompt
- asdf vm
- AeroSpace tiling WM on macOS
- Hypr, rofi, waybar on Linux

## Provision

> "Absorb what is useful, discard what is useless, and add what is specifically your own." — Bruce Lee

To provision a new machine:

```bash
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles

cd ~/Developer/dotfiles

# Install platform-specific prerequisites

# Run the relevant provision command
```

| Platform        | Prerequisites                                                  | Command             |
| --------------- | -------------------------------------------------------------- | ------------------- |
| macOS           | [Homebrew](https://brew.sh), fish                              | `./provision`       |
| Arch Linux      | AUR helper ([paru](https://github.com/Morganamilo/paru)), fish | `./provision-linux` |
| CachyOS         | fish (paru included)                                           | `./provision-linux` |
| Debian / Ubuntu | fish                                                           | `./provision-linux` |

## Sync

Run `./sync` after pulling updates.

## Thanks

Thanks to [@mitchell](https://github.com/mitchell), whose [dotfiles](https://github.com/mitchell/dotfiles) I forked long ago and eventually grew into my own.
