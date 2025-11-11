set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx DIFFPROG nvim -d
set -gx BROWSER zen

set -gx FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude ".git/"'

set -gx GOPATH $HOME/Developer/go
set -gx GOBIN $GOPATH/bin

set -gx ASDF_DATA_DIR $HOME/.local/share/asdf
set -gx ASDF_CONFIG_FILE $HOME/.config/asdf/asdfrc
set -gx BUN_INSTALL_CACHE_DIR $HOME/.cache/bun
set -gx DOCKER_CONFIG $HOME/.config/docker
