#!/usr/bin/env fish

echo 'generating fish completions'

set -l completions_dir ~/.config/fish/completions
mkdir -p $completions_dir

command -q asdf
and asdf completion fish >$completions_dir/asdf.fish

command -q colima
and colima completion fish >$completions_dir/colima.fish

command -q docker
and docker completion fish >$completions_dir/docker.fish

command -q git
and git lfs completion fish >$completions_dir/git-lfs.fish

command -q k3d
and k3d completion fish >$completions_dir/k3d.fish

command -q k9s
and k9s completion fish >$completions_dir/k9s.fish

command -q kubectl
and kubectl completion fish >$completions_dir/kubectl.fish
