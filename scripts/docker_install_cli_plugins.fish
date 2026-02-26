#!/usr/bin/env fish

function log -a message
    set_color blue
    echo -n "==> "
    set_color normal
    echo "$message"
end

log "setting up docker cli-plugins"

set -l plugins_dir (set -q DOCKER_CONFIG; and echo $DOCKER_CONFIG; or echo $HOME/.docker)/cli-plugins
mkdir -p $plugins_dir

# Link Homebrew-installed CLI plugins (compose, buildx, etc.)
set -l brew_prefix (brew --prefix)
for plugin in docker-compose docker-buildx
    set -l brew_bin $brew_prefix/opt/$plugin/bin/$plugin
    if test -x $brew_bin
        ln -sf $brew_bin $plugins_dir/$plugin
    end
end

# Clean up broken symlinks from any legacy Docker Desktop / Rancher Desktop
for f in $plugins_dir/*
    if test -L $f; and not test -e $f
        rm $f
    end
end
