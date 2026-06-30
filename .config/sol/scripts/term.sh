#!/usr/bin/env bash
# name: term
# icon: ⌨️
#
# Jump straight to WezTerm — focus it if it's running, launch it otherwise.
# (Your shell auto-attaches tmux session "base", so you land in tmux.)

export PATH="/opt/homebrew/bin:$PATH"

open -a WezTerm
