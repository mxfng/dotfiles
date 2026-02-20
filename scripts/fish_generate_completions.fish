#!/usr/bin/env fish

# Generate fish shell completions for installed tools
# This script should be run during provisioning or when tools are updated

echo 'generating fish completions'

set -l completions_dir ~/.config/fish/completions

# Create completions directory if it doesn't exist
mkdir -p $completions_dir

# asdf
if command -v asdf >/dev/null 2>&1
    asdf completion fish >$completions_dir/asdf.fish 2>/dev/null
else
    echo 'warning: asdf not found'
end

if command -v colima >/dev/null 2>&1
    colima completion fish >$completions_dir/colima.fish 2>/dev/null
else
    echo 'warning: colima not found'
end

# docker
if command -v docker >/dev/null 2>&1
    docker completion fish >$completions_dir/docker.fish 2>/dev/null
else
    echo 'warning: docker not found'
end

# git-lfs
if command -v git >/dev/null 2>&1
    and git lfs version >/dev/null 2>&1
    git lfs completion fish >$completions_dir/git-lfs.fish 2>/dev/null
else
    echo 'warning: git-lfs not found'
end

# k3d
if command -v k3d >/dev/null 2>&1
    k3d completion fish >$completions_dir/k3d.fish 2>/dev/null
else
    echo 'warning: k3d not found'
end

# k9s
if command -v k9s >/dev/null 2>&1
    k9s completion fish >$completions_dir/k9s.fish 2>/dev/null
else
    echo 'warning: k9s not found'
end

# kubectl
if command -v kubectl >/dev/null 2>&1
    kubectl completion fish >$completions_dir/kubectl.fish 2>/dev/null
else
    echo 'warning: kubectl not found'
end

# yq
if command -v yq >/dev/null 2>&1
    yq shell-completion fish >$completions_dir/yq.fish 2>/dev/null
else
    echo 'warning: yq not found'
end
