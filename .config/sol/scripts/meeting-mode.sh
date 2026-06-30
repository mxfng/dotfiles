#!/usr/bin/env bash
# name: Meeting Mode
# icon: 🔇
#
# One button before a call: mute the mic, Do Not Disturb on, pause music.
# Trigger again to restore your previous mic level and turn DND off.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
DND_ON_SHORTCUT="Do Not Disturb On"
DND_OFF_SHORTCUT="Do Not Disturb Off"
# --------------------------------------------------------------------------

STATE_DIR="${TMPDIR:-/tmp}/sol-modes"
STATEFILE="$STATE_DIR/meeting.input"
mkdir -p "$STATE_DIR"

# Active? Toggle off and restore.
if [[ -f "$STATEFILE" ]]; then
  PREV="$(cat "$STATEFILE" 2>/dev/null)"; [[ -z "$PREV" ]] && PREV=75
  /usr/bin/osascript -e "set volume input volume $PREV" >/dev/null 2>&1 || true
  shortcuts run "$DND_OFF_SHORTCUT" >/dev/null 2>&1 || true
  rm -f "$STATEFILE"
  /usr/bin/osascript -e 'display notification "Mic restored, notifications back." with title "Meeting Mode 🔊"' >/dev/null 2>&1 || true
  echo "Meeting mode off."
  exit 0
fi

# Remember current input level, then mute.
CUR="$(/usr/bin/osascript -e 'input volume of (get volume settings)' 2>/dev/null)"
[[ -z "$CUR" || "$CUR" == "missing value" ]] && CUR=75
echo "$CUR" > "$STATEFILE"

/usr/bin/osascript -e "set volume input volume 0" >/dev/null 2>&1 || true
shortcuts run "$DND_ON_SHORTCUT" >/dev/null 2>&1 || true
/usr/bin/osascript -e 'tell application "System Events" to if (exists process "Music") then tell application "Music" to pause' >/dev/null 2>&1 || true

/usr/bin/osascript -e 'display notification "Mic muted, notifications off." with title "Meeting Mode 🔇"' >/dev/null 2>&1 || true
echo "Meeting mode on."
