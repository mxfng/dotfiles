#!/bin/bash
# Bring a floating window on the current AeroSpace workspace to the front.
# Press again to cycle to the next floating window.
# See aerospace.toml

aerospace=/opt/homebrew/bin/aerospace

floating=$("$aerospace" list-windows --workspace focused --format '%{window-id} %{window-layout}' |
  awk '$2 == "floating" { print $1 }')
[ -z "$floating" ] && exit 0

current=$("$aerospace" list-windows --focused --format '%{window-id}' 2>/dev/null)

# The window after the focused one, or the first if a tile is focused or we wrapped.
next=$(printf '%s\n' "$floating" | awk -v cur="$current" '
  found { print; exit }
  $1 == cur { found = 1 }
')
[ -z "$next" ] && next=$(printf '%s\n' "$floating" | head -1)

"$aerospace" focus --window-id "$next"
