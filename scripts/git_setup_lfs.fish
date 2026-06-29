#!/usr/bin/env fish

source (dirname (status filename))/../.config/fish/functions/log.fish

log "setting up git-lfs"

if command -q git
    and git lfs version >/dev/null 2>&1
    git lfs install
    or echo 'warning: failed to initialize git-lfs'
end
