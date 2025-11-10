# Global environment variables
set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BROWSER arc
set -gx DIFFPROG nvim -d

set -gx FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude ".git/"'

set -gx GOPATH $HOME/Developer/go
set -gx GOBIN $GOPATH/bin

fish_add_path \
    /opt/homebrew/opt/coreutils/libexec/gnubin \
    /opt/homebrew/opt/findutils/libexec/gnubin \
    /opt/homebrew/opt/gnu-sed/libexec/gnubin \
    /opt/homebrew/opt/gnu-tar/libexec/gnubin \
    /opt/homebrew/opt/grep/libexec/gnubin \
    /opt/homebrew/opt/gawk/libexec/gnubin \
    /opt/homebrew/opt/gnu-which/libexec/gnubin \
    $HOME/.local/bin \
    $HOME/Developer/scripts
