# Start SSH agent if not already running
if test -z "$SSH_AUTH_SOCK"; and test -z "$SSH_AGENT_PID"; and test -z "$SSH_CLIENT"
    eval (ssh-agent -c) >/dev/null 2>&1
end

# This isn't the technically correct place for this, but it ensures completions are available
# whenever asdf is installed or updated without manual user intervention.
and mkdir -p ~/.config/fish/completions
and ln -sf "(brew --prefix asdf)"/completions/asdf.fish ~/.config/fish/completions

# Start window management services
restart_wm --sudo

# Auto-attach to tmux session
if status is-interactive
    and not set -q TMUX
    and test -z "$VIM"
    tmux new-session -A -s main
end
