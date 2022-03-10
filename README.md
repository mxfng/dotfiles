# max's dotfiles

A dotfile repo that exists to make it easier for me to bootstrap onto new systems. Nothing special, really. Some scripts are my own, other scripts are inspired by others' hard work.

## Contained Configurations

* zsh shell
* git
* hyper terminal
* keepassxc
* yabaiwm
* skhd
* conky

## Scripts

### `sync`

#### Dependencies

* fish
* git
* neovim
* rsync
* curl

#### Description

Syncs all configuration files found in this repository to your home folder.

To run sync script using curl: `curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | zsh`