# Max's dotfiles

My personal dotfiles for macOS.

A Linux setup used to live here.
It is preserved in the `archive/linux` git tag.

- fish shell
- Neovim
- WezTerm
- tmux
- Starship prompt
- asdf vm
- AeroSpace tiling WM

## Provision

> "Absorb what is useful, discard what is useless, and add what is specifically your own." — Bruce Lee

To provision a new Mac:

```bash
# Install Homebrew and fish first
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles

cd ~/Developer/dotfiles
./provision
```

## Sync

Run `./sync` after pulling updates.

## Thanks

Thanks to [@mitchell](https://github.com/mitchell), whose [dotfiles](https://github.com/mitchell/dotfiles) I forked long ago and eventually grew into my own.
