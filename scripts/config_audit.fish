#!/usr/bin/env fish

# Audit ~/.config for unrecognized directories not tracked by dotfiles.
#
# Usage:
#   config_audit.fish         # audit only; list unknowns
#   config_audit.fish --clean # prompt to delete each unknown
#   config_audit.fish --purge # auto-delete all unknowns

set dotfiles_config ~/Developer/dotfiles/.config

# Tool-generated dirs expected in ~/.config/ but not tracked in dotfiles
set -l manual_allowlist \
    btop \
    colima \
    docker \
    gcloud \
    gh \
    k9s \
    kube \
    lazydocker \
    lazygit \
    mole \
    opencode \
    sol

# Parse flags
set -l mode audit
set -l quiet false
for arg in $argv
    switch $arg
        case --clean
            set mode clean
        case --purge
            set mode purge
        case --quiet -q
            set quiet true
        case '*'
            echo "unknown flag: $arg" >&2
            exit 1
    end
end

# Build allowlist from tracked dotfiles + manual entries
set -l allowlist $manual_allowlist
for entry in $dotfiles_config/*
    set -a allowlist (basename $entry)
end

# Find unknowns
set -l unknowns
for entry in ~/.config/*/
    set -l name (basename $entry)
    if not contains $name $allowlist
        set -a unknowns $name
    end
end

# TODO: How can I get this if statement to only print a "all configs clean for --purge and --clean modes?"
if test (count $unknowns) -eq 0
    if test $quiet = false
        echo "~/.config/ is clean"
    end
    exit 0
end

set_color yellow
echo "found "(count $unknowns)" unrecognized entries in ~/.config/:"
set_color normal

switch $mode
    case audit
        for name in $unknowns
            set_color yellow
            echo "  ? $name"
            set_color normal
        end
    case clean
        for name in $unknowns
            read -P "  delete ~/.config/$name/? [y/N] " confirm
            if test "$confirm" = y -o "$confirm" = Y
                rm -rf ~/.config/$name
                echo "    deleted"
            else
                echo "    skipped"
            end
        end
    case purge
        for name in $unknowns
            rm -rf ~/.config/$name
            echo "  deleted $name"
        end
end
