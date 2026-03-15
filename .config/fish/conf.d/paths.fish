# GNU tools have path priority over macOS builtins
if test -d /opt/homebrew
    fish_add_path \
        /opt/homebrew/opt/coreutils/libexec/gnubin \
        /opt/homebrew/opt/findutils/libexec/gnubin \
        /opt/homebrew/opt/gawk/libexec/gnubin \
        /opt/homebrew/opt/gnu-sed/libexec/gnubin \
        /opt/homebrew/opt/gnu-tar/libexec/gnubin \
        /opt/homebrew/opt/gnu-which/libexec/gnubin \
        /opt/homebrew/opt/grep/libexec/gnubin
end

fish_add_path \
    $HOME/.local/bin \
    $HOME/Developer/scripts
