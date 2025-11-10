# Order matters: asdf shims must come first, then GNU tools, then custom paths

# ASDF shims - must be first to override system versions
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# GNU coreutils and custom paths
fish_add_path \
    /opt/homebrew/opt/coreutils/libexec/gnubin \
    /opt/homebrew/opt/findutils/libexec/gnubin \
    /opt/homebrew/opt/gnu-sed/libexec/gnubin \
    /opt/homebrew/opt/gnu-tar/libexec/gnubin \
    /opt/homebrew/opt/grep/libexec/gnubin \
    /opt/homebrew/opt/gawk/libexec/gnubin \
    /opt/homebrew/opt/gnu-which/libexec/gnubin \
    $HOME/.local/bin \
    $HOME/Developer/scripts
