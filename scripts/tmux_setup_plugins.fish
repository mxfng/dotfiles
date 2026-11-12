#!/usr/bin/env fish

source (dirname (status filename))/../.config/fish/functions/ohai.fish

ohai "setting up tmux plugins"

if not test -d ~/.config/tmux/plugins/tpm
    set -l err (git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm 2>&1)
    or begin
        echo "warning: failed to install tmux plugin manager: $err"
        exit 0
    end
end

~/.config/tmux/plugins/tpm/bin/install_plugins
or echo 'warning: failed to install tmux plugins'
