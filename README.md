# max's dotfiles

A dotfile repo that exists to make it easier for me to bootstrap onto new systems. Nothing special, really.

![mxfng.dotfiles](/img/cap.png)

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

Execute `sync` from your local instance of the repository using `sh sync.sh` or using curl with `curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync.sh | sh`

## Installation

### Prerequisites

* Homebrew [macOS] 

### Instructions

1. Clone repo.
2. In the newly cloned **dotfiles** folder, run `sh sync.sh`
3. Configure iTerm2.
   1. Go to Preferences > General > Preferences and check **load preferences from a custom folder or URL**, then set the directory to `.../dotfiles/.config/iTerm2` (make sure to include the entire path up to your cloned dotfiles repo)
4. Configure Alfred.
   1. In Alfred Preferences, on the General tab, change the **Alfred Hotkey** to **Command + Space**.
5. More coming soon...