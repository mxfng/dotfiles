set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BROWSER zen
set -gx DIFFPROG nvim -d

set -gx FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude ".git/"'

set -gx GOPATH $HOME/Developer/go
set -gx GOBIN $GOPATH/bin
