#!/usr/bin/env bash
# name: Exit Studio Mode
# icon: 🎚️
#
# Wind down from music-making: turn Do Not Disturb back off, and optionally
# quit Logic Pro.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
DND_OFF_SHORTCUT="Do Not Disturb Off"
QUIT_LOGIC=false           # true: also quit Logic Pro (it'll prompt to save)
# --------------------------------------------------------------------------

shortcuts run "$DND_OFF_SHORTCUT" >/dev/null 2>&1 || true

if [[ "$QUIT_LOGIC" == "true" ]]; then
  /usr/bin/osascript -e 'tell application "Logic Pro" to quit' >/dev/null 2>&1 || true
fi

/usr/bin/osascript -e 'display notification "Notifications back on. Nice session." with title "Exit Studio Mode 🎚️"' >/dev/null 2>&1 || true
echo "Studio mode off."
