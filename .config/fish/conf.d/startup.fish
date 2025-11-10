# Start SSH agent if not already running
if test -z "$SSH_AUTH_SOCK"; and test -z "$SSH_AGENT_PID"; and test -z "$SSH_CLIENT"
    eval (ssh-agent -c) >/dev/null 2>&1
end

# Generate completions for dependencies
# This isn't the technically correct place for this, but it ensures completions are available
# whenever dependencies are installed or updated without manual user intervention.
mkdir -p ~/.config/fish/completions

if command -v asdf >/dev/null 2>&1
    ln -sf (brew --prefix asdf)/completions/asdf.fish ~/.config/fish/completions 2>/dev/null
end

if command -v docker >/dev/null 2>&1
    docker completion fish >~/.config/fish/completions/docker.fish 2>/dev/null
end

# Start window management services
# Passwordless sudo is configured via ./scripts/yabai_setup_sa.fish or running ./provision desktop
restart_wm --sudo

# Auto-attach to tmux session
if status is-interactive
    and not set -q TMUX
    and test -z "$VIM"
    tmux new-session -A -s main
end
