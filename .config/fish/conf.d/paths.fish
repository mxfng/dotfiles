# Homebrew first: each fish_add_path prepends, so the GNU paths below land ahead of it
if test -f /opt/homebrew/bin/brew
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
else if test -f /usr/local/bin/brew
    fish_add_path /usr/local/bin
    fish_add_path /usr/local/sbin
end

# NOTE: GNU tools have path priority over macOS builtins
if test -d /opt/homebrew
    fish_add_path \
        /opt/homebrew/opt/coreutils/libexec/gnubin \
        /opt/homebrew/opt/findutils/libexec/gnubin \
        /opt/homebrew/opt/gawk/libexec/gnubin \
        /opt/homebrew/opt/gnu-sed/libexec/gnubin \
        /opt/homebrew/opt/gnu-tar/libexec/gnubin \
        /opt/homebrew/opt/gnu-which/libexec/gnubin \
        /opt/homebrew/opt/grep/libexec/gnubin \
        /opt/homebrew/opt/rustup/bin
end

fish_add_path \
    $HOME/.local/bin \
    $HOME/.local/share/pnpm \
    $HOME/.local/share/cargo/bin \
    $HOME/Developer/go/bin \
    $HOME/Developer/scripts
