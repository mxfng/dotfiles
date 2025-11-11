# Additional configuration is loaded automatically from conf.d/

umask 077

# Login shell initialization
# These commands only run once per login, not on every new shell/tmux window
if status is-login
    # Generate completions for dependencies
    # This ensures completions are available whenever dependencies are installed or updated
    # without manual user intervention.
    mkdir -p ~/.config/fish/completions

    if command -v asdf >/dev/null 2>&1
        fish -c "ln -sf (brew --prefix asdf)/completions/asdf.fish ~/.config/fish/completions 2>/dev/null" &
        disown
    end

    if command -v docker >/dev/null 2>&1
        fish -c "docker completion fish >~/.config/fish/completions/docker.fish 2>/dev/null" &
        disown
    end

    # Start window management services
    # Passwordless sudo is configured via ./scripts/yabai_setup_sa.fish or running ./provision desktop
    fish -c "restart_wm --sudo" &
    disown
end
