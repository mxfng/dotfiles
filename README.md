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

# Provision terminal (installs packages, sets up shell)
./provision terminal | fish

# Optionally, provision desktop (window management, GUI apps)
./provision desktop
```

## Scripts

### `provision`

Sets up a fresh macOS environment.

**Commands:**

- `./provision terminal` - Install CLI tools (fish, nvim, tmux) and sync configs
- `./provision desktop` - Install GUI apps (yabai, skhd, WezTerm) and sync configs

### `sync`

Syncs dotfiles from repo to home directory. Run after pulling updates.

**Usage:**

```bash
./sync              # Sync terminal configs (fish, nvim, tmux, etc.)
./sync --desktop    # Sync desktop configs (wezterm, skhd)
./sync --git        # Sync git config and set user
```

## Thanks

I forked [Mitchell Simon's](https://github.com/mitchell/dotfiles) excellent dotfiles for some time and eventually used them as a guiding inspiration for my own. A decent amount of the code here stems from or was inspired by Mitchell's original project. Thanks Mitchell!
