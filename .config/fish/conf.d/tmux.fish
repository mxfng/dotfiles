# Auto-attach to tmux session
if status is-interactive
    and not set -q TMUX
    and test -z "$VIM"
    tmux new-session -A -s base
end
