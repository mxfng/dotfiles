#!/usr/bin/env fish

source (dirname (status filename))/../.config/fish/functions/log.fish

log 'generating fish completions'

set -l completions_dir ~/.config/fish/completions
mkdir -p $completions_dir

command -q asdf
and asdf completion fish >$completions_dir/asdf.fish

command -q gh
and gh completion -s fish >$completions_dir/gh.fish

command -q tailscale
and tailscale completion fish >$completions_dir/tailscale.fish

command -q uv
and uv generate-shell-completion fish >$completions_dir/uv.fish
