# max's dotfiles

A dotfile repo that exists to make it easier for me to bootstrap onto new systems. Nothing special, really.

## Configurations

* zsh shell
* git
* iTerm2 Terminal
* keepassxc

## Scripts

### `sync`

Run to synchronize dotfiles from the repo to `$HOME` and refresh the Brewfile. Can install dotfiles as well as maintain any updates.

#### Dependencies
* Homebrew
* coreutils

Execute `sync` for the first time with `curl https://raw.githubusercontent.com/mxfng/dotfiles/main/sync.sh | sh` to install dotfiles. Afterward just run the command `sync` to keep dotfiles updated.

## Installation
### Instructions

1. Run `curl https://raw.githubusercontent.com/mxfng/dotfiles/main/sync.sh | sh` in your Terminal.
2. To sync iTerm2 preferences with this repo, open the app.
   1. Go to Preferences > General > Preferences and check **load preferences from a custom folder or URL**, then set the directory to `.../dotfiles/.config/iTerm2` (make sure to include the entire path up to your cloned dotfiles repo)