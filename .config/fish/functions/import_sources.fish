function import_sources -a uname -d 'Loads any additional fish files needed at init.'
    test -e /opt/homebrew/bin/brew
    and /opt/homebrew/bin/brew shellenv | source -

    # ASDF configuration code
    if test -z $ASDF_DATA_DIR
        set _asdf_shims "$HOME/.asdf/shims"
    else
        set _asdf_shims "$ASDF_DATA_DIR/shims"
    end

    # Do not use fish_add_path (added in Fish 3.2) because it
    # potentially changes the order of items in PATH
    if not contains $_asdf_shims $PATH
        set -gx --prepend PATH $_asdf_shims
    end
    set --erase _asdf_shims

    test -e "(brew --prefix asdf)"/libexec/asdf.fish
    and source "(brew --prefix asdf)"/libexec/asdf.fish
    and mkdir -p ~/.config/fish/completions
    and ln -sf "(brew --prefix asdf)"/completions/asdf.fish ~/.config/fish/completions

    command -q starship; and starship init fish | source
    command -q zoxide; and zoxide init fish | source
    command -q fzf; and fzf --fish | source
    command -q pyenv; and pyenv init - | source
end
