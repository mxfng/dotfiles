# Max's dotfiles

My preferred setup for Macs. My tools are mostly terminal-based, with tiling window management and keyboard-heavy workflows. This repo includes scripts to quickly bootstrap new systems and keep them manually synced.

- Neovim
- tmux
- fish shell
- WezTerm
- AeroSpace tiling WM
- Starship prompt
- asdf vm
- Sol

## Provision

To provision a new Mac:

```bash
# Install Homebrew and fish first
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles

cd ~/Developer/dotfiles
./provision
```

Provision installs my workspace and configs. There are optional steps to set preferred macOS defaults. The script is idempotent (can be run more than once).

## Sync

Run `./sync` after pulling updates, then `reload` to load them into running tools.

Configs tracked in this repo are the source of truth for every machine. I make config changes here and push them, and avoid editing the deployed copies in the home folder.

## How I maintain this repo

> "Absorb what is useful, discard what is useless, and add what is specifically your own." — Bruce Lee

When adding or changing anything here, I try to keep my tools and their configurations simple, minimal, and tidy. Changes in my workflow, preferences, development, and usage patterns cause drift, which accumulates as debt, so in general, less is more. Things survive here when they prove useful and are simple (or important) enough to understand and maintain myself.

## Thanks

Thanks to [@mitchell](https://github.com/mitchell), whose [dotfiles](https://github.com/mitchell/dotfiles) I forked long ago and eventually grew into my own.
