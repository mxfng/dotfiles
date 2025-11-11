# Start SSH agent if not already running
if test -z "$SSH_AUTH_SOCK"; and test -z "$SSH_AGENT_PID"; and test -z "$SSH_CLIENT"
    eval (ssh-agent -c) >/dev/null 2>&1
end

# Auto-attach to tmux session
if status is-interactive
    and not set -q TMUX
    and test -z "$VIM"
    tmux new-session -A -s main
end

# Start window management services if not running
# Passwordless sudo is configured via ./scripts/yabai_setup_sa.fish or running ./provision desktop
if not pgrep -x yabai >/dev/null 2>&1; or not pgrep -x skhd >/dev/null 2>&1
    fish -c "restart_wm --sudo" &
    disown
end
