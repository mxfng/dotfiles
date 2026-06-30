#!/usr/bin/env bash
# name: Morning Boot
# icon: 🌅
#
# Start-of-day ritual in one press: open your daily tabs, fire up WezTerm,
# turn Do Not Disturb off, and pop the calendar.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
TABS=(
  "https://mail.google.com"
  "https://calendar.google.com"
  "https://github.com/notifications"
)
OPEN_CALENDAR_APP=true
DND_OFF_SHORTCUT="Do Not Disturb Off"
# --------------------------------------------------------------------------

shortcuts run "$DND_OFF_SHORTCUT" >/dev/null 2>&1 || true

for url in "${TABS[@]}"; do
  open "$url" >/dev/null 2>&1 || true
done

open -a WezTerm >/dev/null 2>&1 || true
[[ "$OPEN_CALENDAR_APP" == "true" ]] && open -a Calendar >/dev/null 2>&1 || true

/usr/bin/osascript -e "display notification \"Good morning. Everything's up.\" with title \"Morning Boot 🌅\"" >/dev/null 2>&1 || true
echo "Morning boot complete."
