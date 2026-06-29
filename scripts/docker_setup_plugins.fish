#!/usr/bin/env fish

source (dirname (status filename))/../.config/fish/functions/log.fish

log "cleaning up docker cli-plugins"

# Docker CLI from Homebrew bundles compose and buildx as built-in subcommands.
# The standalone docker-compose and docker-buildx Homebrew formulae provide
# the hyphenated binaries for scripts that need them — no CLI plugin symlinks
# needed anymore.

set -l plugins_dir (set -q DOCKER_CONFIG; and echo $DOCKER_CONFIG; or echo $HOME/.docker)/cli-plugins

# Clean up broken symlinks from any legacy Docker Desktop / Rancher Desktop installs
if test -d $plugins_dir
    for f in $plugins_dir/*
        if test -L $f; and not test -e $f
            rm $f
        end
    end
end
