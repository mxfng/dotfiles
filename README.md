# dotfiles

This repo contains my preferred configurations for:

- fish shell
- code | cursor
- git
- yabaiwm (macOS)
- skhd (macOS)
- wezterm

# Quick Start

To get the dotfiles quickly, you can run the sync script:
```bash
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish
```

## Fresh macOS Installation

1. [Install brew](https://docs.brew.sh/Installation)

2. Install fish
```bash
brew install fish
```

3. (Optional) Clone the repository:
```bash
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
```

4. Run terminal provisioning (installs terminal packages from Brewfile):
```bash
./provision terminal
```

5. (Optional) Run desktop provisioning (installs desktop apps and configures services):
```bash
./provision desktop
```

6. Run the synchronization scripts
```bash
./sync --install
./sync --desktop
./sync --git
```

The desktop provisioning will:
- Install desktop applications from Brewfile
- Configure Raycast hotkey (disables Spotlight)
- Set up Yabai and SKHD services
- Add WezTerm and Raycast to login items

## Sync Options

The sync script provides several options:
- `--install`: Basic setup (Fish config, scripts)
- `--desktop`: Desktop environment (WezTerm, Yabai, SKHD)
- `--git`: Git configuration
- `--help`: Show help message

Example:
```bash
# Show help
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish -c 'sync --help'

# Install everything
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish -c 'sync --install --desktop --git'
```

# Scripts

## `provision`

A collection of functions for provisioning macOS environments. The script can:
- Install Homebrew if not present
- Install packages from Brewfile
- Set up terminal environment
- Configure desktop environment and services
- Manage login items
- Configure Raycast hotkey

### Dependencies

- fish
- xcode (maybe?) todo: validate this

## `sync`

Syncs all configuration files found in this repository to your home folder.

### Dependencies

- fish
- git
- rsync
- curl

To run this script with curl:
```bash
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish

# desktop config, use -d or --desktop
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish -s -- -d

# git config, use -g or --git
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish -s -- -g
```

# Keyboard Shortcuts

A list of keyboard shortcuts is defined in `.skhdrc`