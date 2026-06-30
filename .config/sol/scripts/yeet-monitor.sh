#!/usr/bin/env bash
# name: Yeet to Monitor
# icon: 🪃
#
# Fling the focused window to the next monitor and follow it there.
# (No-op on a single display.)

export PATH="/opt/homebrew/bin:$PATH"

aerospace move-node-to-monitor --focus-follows-window --wrap-around next
