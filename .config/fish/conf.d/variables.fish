set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_DESKTOP_DIR $HOME/Desktop
set -gx XDG_DOWNLOAD_DIR $HOME/Downloads
set -gx XDG_DOCUMENTS_DIR $HOME/Documents
set -gx XDG_MUSIC_DIR $HOME/Music
set -gx XDG_PICTURES_DIR $HOME/Pictures
set -gx XDG_VIDEOS_DIR $HOME/Videos

set -gx TERMINAL wezterm
set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx DIFFPROG nvim -d
set -gx BROWSER zen

set -gx FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude ".git/"'

set -gx ASDF_DATA_DIR $HOME/.local/share/asdf
set -gx ASDF_CONFIG_FILE $HOME/.config/asdf/asdfrc

set -gx GOPATH $HOME/Developer/go
set -gx GOBIN $GOPATH/bin

set -gx BUN_INSTALL_CACHE_DIR $HOME/.cache/bun

set -gx DOCKER_CONFIG $HOME/.config/docker

set -gx LESSHISTFILE $XDG_STATE_HOME/less/history
set -gx PSQL_HISTORY $XDG_STATE_HOME/psql/history
set -gx NODE_REPL_HISTORY $XDG_STATE_HOME/node/history
set -gx NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm
