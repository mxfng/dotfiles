function define_global_variables -d 'Defines all and exclusively globally exported variables'
    set -gx EDITOR nvim
    set -gx BROWSER arc
    set -gx DIFFPROG nvim -d

    set -gx FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --type d --hidden --exclude ".git/"'
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude ".git/"'

    set -gx GOPATH $HOME/Developer/go
    set -gx GOBIN $GOPATH/bin

    fish_add_path \
        $HOME/.local/bin \
        $HOME/Developer/scripts
end
