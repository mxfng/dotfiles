#!/usr/bin/env bash
# name: Exit Studio Mode
# icon: 🎚️
#
# Wind down from music-making: turn Do Not Disturb off, return the windows
# Studio Mode displaced to where they were, and quit Logic Pro.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
DND_OFF_SHORTCUT="Do Not Disturb Off"
# --------------------------------------------------------------------------

STATE_DIR="${TMPDIR:-/tmp}/sol-modes"
STATEFILE="$STATE_DIR/studio-evac.state"

shortcuts run "$DND_OFF_SHORTCUT" >/dev/null 2>&1 || true

# Move the evacuated windows back to their original workspace, then end up
# there ourselves. (State written by Studio Mode: line 1 = workspace, rest =
# window ids.)
origin=""
if [[ -f "$STATEFILE" ]]; then
  {
    read -r origin
    while read -r wid; do
      [[ -n "$wid" ]] && aerospace move-node-to-workspace --window-id "$wid" "$origin" >/dev/null 2>&1 || true
    done
  } < "$STATEFILE"
  rm -f "$STATEFILE"
fi

# Quit Logic (it'll prompt to save if there are unsaved changes).
/usr/bin/osascript -e 'tell application "Logic Pro" to quit' >/dev/null 2>&1 || true

[[ -n "$origin" ]] && aerospace workspace "$origin" >/dev/null 2>&1 || true

/usr/bin/osascript -e 'display notification "Windows restored, Logic closed. Nice session." with title "Exit Studio Mode 🎚️"' >/dev/null 2>&1 || true
echo "Studio mode off."
