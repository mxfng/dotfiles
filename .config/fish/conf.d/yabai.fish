# Start window management services if not running
# Passwordless sudo is configured via ./scripts/yabai_setup_sa.fish or running ./provision desktop
if not pgrep -x yabai >/dev/null 2>&1; or not pgrep -x skhd >/dev/null 2>&1
    fish -c "restart_wm --sudo" &
    disown
end
