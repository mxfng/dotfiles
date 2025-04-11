# dotfiles

A collection of software and configurations for bootstrapping new macOS systems.

It has my preferred configurations for:

- fish shell
- git
- yabaiwm (macOS)
- skhd (macOS)
- wezterm

# Quick Start

To get the configurations quickly, you can run the sync script:
```bash
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish
```

## Fresh macOS Installation

[Install brew](https://docs.brew.sh/Installation)

Install fish
```bash
brew install fish
```

Run terminal provisioning and follow prompts
```bash
./provision terminal | fish
```

The provision script will ask if you want to optionally run the sync scripts for desktop and git configs.

You can clone the repository for local development like so:
```bash
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles
```

To update configs, you can run the sync script.

I also like to set my hotkey to cmd + space for Raycast (Spotlight replacement)

# Scripts

## `provision`

A collection of functions for provisioning macOS environments.

### Dependencies

- fish

## `sync`

Syncs all configuration files found in this repository to your home folder.

### Dependencies

- fish
- git
- rsync
- curl

To run this script with curl:
```bash
# Basic install
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish

# Desktop config
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish -s -- --desktop

# Git config
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish -s -- --git
```

# Keyboard Shortcuts

A list of keyboard shortcuts is defined in `.skhdrc`