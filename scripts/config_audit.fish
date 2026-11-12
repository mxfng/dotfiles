#!/usr/bin/env fish

# Audit ~/.config for directories not tracked by dotfiles. Report only; delete strays by hand.
#
# Usage:
#   config_audit.fish          # list unknowns, or report clean
#   config_audit.fish --quiet  # print nothing when clean

# Tool-generated dirs expected in ~/.config/ but not tracked in dotfiles
set -l allowlist \
    btop \
    configstore \
    gh \
    go \
    homebrew \
    net.imput.helium \
    Slack
for entry in ~/Developer/dotfiles/.config/*
    set -a allowlist (basename $entry)
end

set -l unknowns
for entry in ~/.config/*/
    contains -- (basename $entry) $allowlist
    or set -a unknowns (basename $entry)
end

if test (count $unknowns) -eq 0
    contains -- --quiet $argv; or echo '~/.config/ is clean'
    exit 0
end

set_color yellow
echo 'unrecognized entries in ~/.config/:'
printf '  ? %s\n' $unknowns
set_color normal
