# Auto-attach to tmux session
# WezTerm only
if status is-interactive
    and not set -q TMUX
    and test -z "$VIM"
    and test "$TERM_PROGRAM" = WezTerm
    tmux new-session -A -s base
end
