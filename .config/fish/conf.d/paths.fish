if test -d /opt/homebrew
    # NOTE: GNU tools have path priority over macOS builtins
    fish_add_path \
        /opt/homebrew/opt/coreutils/libexec/gnubin \
        /opt/homebrew/opt/findutils/libexec/gnubin \
        /opt/homebrew/opt/gawk/libexec/gnubin \
        /opt/homebrew/opt/gnu-sed/libexec/gnubin \
        /opt/homebrew/opt/gnu-tar/libexec/gnubin \
        /opt/homebrew/opt/gnu-which/libexec/gnubin \
        /opt/homebrew/opt/grep/libexec/gnubin \
        /opt/homebrew/opt/rustup/bin \
        /opt/homebrew/bin \
        /opt/homebrew/sbin
end

fish_add_path \
    $HOME/.local/bin \
    $PNPM_HOME \
    $CARGO_HOME/bin \
    $GOBIN \
    $HOME/Developer/scripts
