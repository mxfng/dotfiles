# Max's dotfiles

My preferred configurations and software for macOS systems. Uses fish shell, Neovim, yabai, skhd, tmux, WezTerm, Starship prompt, Homebrew, asdf runtime version manager, and other great tools.

## Setup

It's highly recommended that you read through my dotfiles with scrutiny before incorporating them as your own. In the words of the late, great Bruce Lee: "absorb what is useful, discard what is useless, and add what is specifically your own."

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone this repo
git clone https://github.com/mxfng/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles

# Install fish shell (ensure brew is added to PATH)
brew install fish

# Provision complete macOS environment
./provision | fish
```

## Scripts

### `provision`

Provisions a complete macOS environment. Run this when starting from scratch.

### `sync`

Syncs all dotfiles from repo to home directory. Run this after pulling updates.

## Thanks

I forked Mitchell Simon's excellent [dotfiles](https://github.com/mitchell/dotfiles) for some time and eventually used them as a guiding inspiration for my own. A decent amount of the code here stems from or was inspired by Mitchell's original project. Thanks Mitchell!
