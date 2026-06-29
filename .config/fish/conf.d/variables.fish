set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_DESKTOP_DIR $HOME/Desktop
set -gx XDG_DOCUMENTS_DIR $HOME/Documents
set -gx XDG_DOWNLOAD_DIR $HOME/Downloads
set -gx XDG_MUSIC_DIR $HOME/Music
set -gx XDG_PICTURES_DIR $HOME/Pictures
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_VIDEOS_DIR $HOME/Videos

set -gx BROWSER zen
set -gx DIFFPROG nvim -d
set -gx EDITOR nvim
set -gx TERM xterm-256color
set -gx TERMINAL wezterm
set -gx VISUAL nvim

set -gx ASDF_DATA_DIR $XDG_DATA_HOME/asdf
set -gx ASDF_CONFIG_FILE $XDG_CONFIG_HOME/asdf/asdfrc

set -gx BOTO_CONFIG $XDG_CONFIG_HOME/gcloud/.boto

set -gx BUN_INSTALL_CACHE_DIR $XDG_CACHE_HOME/bun

set -gx BUNDLE_USER_CACHE $XDG_CACHE_HOME/bundle
set -gx BUNDLE_USER_CONFIG $XDG_CONFIG_HOME/bundle

set -gx DOCKER_CONFIG $XDG_CONFIG_HOME/docker

set -gx FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude ".git/"'

set -gx GEM_SPEC_CACHE $XDG_CACHE_HOME/gem

set -gx GOPATH $HOME/Developer/go
set -gx GOBIN $GOPATH/bin

set -gx HERMES_HOME $XDG_CONFIG_HOME/hermes

set -gx KUBECONFIG $XDG_CONFIG_HOME/kube/config:$XDG_CONFIG_HOME/kube/prod.yaml
set -gx KUBECACHEDIR $XDG_CACHE_HOME/kube

set -gx LESSHISTFILE $XDG_STATE_HOME/less/history

set -gx NODE_REPL_HISTORY $XDG_STATE_HOME/node/history

set -gx NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm

set -gx PSQL_HISTORY $XDG_STATE_HOME/psql/history
