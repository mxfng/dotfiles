# max's dotfiles

A dotfile repo that exists to make it easier for me to bootstrap onto new systems. Nothing special, really. It is notably free of Oh-My-Zsh, which is atypical of most zsh configurations, and has a variety of aesthetic and quality of life tweaks and improvements that I enjoy in my daily work. Please feel free to use any of these files or take some inspiration from them for your own dotfiles.

![mxfng.dotfiles](img/capture.png)

## Configurations

* zsh
* git
* iTerm2 Terminal
* python
* vim
* keepassxc

## Scripts

### `sync`

Run to synchronize dotfiles from the repo to `$HOME` and refresh the Brewfile. Can install dotfiles as well as maintain any updates.

#### Dependencies
* macOS
* git

Execute `sync` for the first time with `curl https://raw.githubusercontent.com/mxfng/dotfiles/main/sync | zsh` to install dotfiles. Afterward just run the command `sync` to keep dotfiles updated.

## Installation

1. Open up Terminal and close all other applications (if they will be upgraded by the Brewfile).
2. Run `curl https://raw.githubusercontent.com/mxfng/dotfiles/main/sync | zsh` in your Terminal.
3. Close Terminal and open up iTerm2.
4. To sync iTerm2 preferences with this repo, do the following:
   1. Go to Preferences > General > Preferences and check **load preferences from a custom folder or URL**, then click cancel on the popup to type the URL in manually. Set the directory to `~/Developer/dotfiles/.config/iTerm2`
5. Open **System Preferences** > Users & Groups > Login Items and make sure that **iTerm** is added and **Hide** is selected.
6. Fully quit iTerm2 by pressing `cmd + Q`, wait a moment, then reopen it for the repo preferences to load properly.