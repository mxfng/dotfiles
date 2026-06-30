#!/usr/bin/env bash
# name: Balance Layout
# icon: ⚖️
#
# Tidy a messy workspace: flatten any nested containers and even out every
# window to equal sizes.

export PATH="/opt/homebrew/bin:$PATH"

aerospace flatten-workspace-tree
aerospace balance-sizes
