function restart_wm --description "Restart yabai and skhd window management services"
    argparse 's/sudo' -- $argv

    # Start or restart yabai
    if pgrep -x yabai >/dev/null 2>&1
        yabai --restart-service >/dev/null 2>&1
    else
        yabai --start-service >/dev/null 2>&1
    end

    # Start or restart skhd
    if pgrep -x skhd >/dev/null 2>&1
        skhd --restart-service >/dev/null 2>&1
    else
        skhd --start-service >/dev/null 2>&1
    end

    # Load scripting addition if requested
    if set -q _flag_sudo
        sudo yabai --load-sa >/dev/null 2>&1
    end
end
