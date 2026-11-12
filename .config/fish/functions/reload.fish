function reload --description 'Load new config into dependencies and this shell'
    tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null # only when a tmux server is running
    command -q aerospace; and aerospace reload-config
    exec fish
    # other deps omitted either reload independently or must be restarted manually
end
