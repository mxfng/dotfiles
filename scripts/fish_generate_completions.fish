#!/usr/bin/env fish

# Generate fish shell completions for installed tools
# This script should be run during provisioning or when tools are updated

echo 'Generating fish completions...'

set -l completions_dir ~/.config/fish/completions

# Create completions directory if it doesn't exist
mkdir -p $completions_dir

# asdf
if command -v asdf >/dev/null 2>&1
    asdf completion fish >$completions_dir/asdf.fish 2>/dev/null
else
    echo 'warning: asdf not found'
end

# docker
if command -v docker >/dev/null 2>&1
    docker completion fish >$completions_dir/docker.fish 2>/dev/null
else
    echo 'warning: docker not found'
end
