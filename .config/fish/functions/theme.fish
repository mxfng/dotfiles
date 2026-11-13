function theme --description 'Switch the terminal theme: theme [name]'
    # Writes the theme name to a state file. WezTerm reloads at once,
    # Neovim switches when it regains focus, and tmux and Starship use the
    # terminal's ANSI colors, so they follow WezTerm.
    set -l registry ~/.config/theme/themes.tsv
    set -l state ~/.local/state/theme
    set -l names (string match -rv '^#' <$registry | string split -f1 \t)
    set -l current (cat $state 2>/dev/null; or echo rose-pine-moon)

    set -l pick $argv[1]
    if test -z "$pick"
        set pick (printf '%s\n' $names | fzf --prompt 'theme> ' --header "current: $current" --height 40% --reverse)
        or return 1
    end

    if not contains -- $pick $names
        echo "theme: unknown theme '$pick'. Choose one of: $names" >&2
        return 1
    end

    mkdir -p (path dirname $state)
    echo $pick >$state
    echo "theme: $pick"
end
