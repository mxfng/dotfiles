function auto_attach_tmux --description "Auto start or attach to tmux session"
    if status is-interactive
        and not set -q TMUX
        and test -z "$VIM"
        tmux new-session -A -s main
    end
end
