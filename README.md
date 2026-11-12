# Max's dotfiles

My personal dotfiles for macOS.

- fish shell
- Neovim
- WezTerm
- tmux
- Starship prompt
- asdf vm
- AeroSpace tiling WM

I try to keep my tools and their configs minimalist and tidy for maintainability.

## Provision

> "Absorb what is useful, discard what is useless, and add what is specifically your own." — Bruce Lee

To provision a new Mac:

```bash
# Install Homebrew and fish first
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles

cd ~/Developer/dotfiles
./provision
```

Provision is designed to be idempotent and can be run on a machine more than once as updates occur.

## Sync

Run `./sync` after pulling updates.

Configuration files tracked in this repository are the source of truth for their machine. All updates to configuration should be made here, not in the home folder.

## Thanks

Thanks to [@mitchell](https://github.com/mitchell), whose [dotfiles](https://github.com/mitchell/dotfiles) I forked long ago and eventually grew into my own.
