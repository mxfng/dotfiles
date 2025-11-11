# Max's dotfiles

My preferred configurations and software for macOS systems.

## Quickstart

```bash
# Install Homebrew + fish first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install fish

# Clone this repo
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles

# Provision complete macOS environment
./provision | fish
```

## Scripts

### `provision`

Provisions a complete macOS environment.

### `sync`

Syncs all dotfiles from repo to home directory. Run after pulling updates

## Thanks

I forked [Mitchell Simon's](https://github.com/mitchell/dotfiles) excellent dotfiles for some time and eventually used them as a guiding inspiration for my own. A decent amount of the code here stems from or was inspired by Mitchell's original project. Thanks Mitchell!
