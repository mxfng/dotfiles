#!/usr/bin/env bash
# name: Morning Boot
# icon: 🌅
#
# Start-of-day ritual in one press: open your daily tabs, fire up WezTerm,
# turn Do Not Disturb off, and pop the calendar.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
# Opened in order; the LAST one becomes the active tab, so Calendar is last.
TABS=(
  "https://mail.google.com"            # Gmail
  "https://github.com"                 # GitHub
  "https://news.ycombinator.com"       # news — swap for your preferred site
  "https://pitchfork.com"              # music news — swap to taste
  "https://calendar.google.com"        # Google Calendar — foregrounded last
)
OPEN_REMINDERS=true        # Apple Reminders app (you actually use this one)
DND_OFF_SHORTCUT="Do Not Disturb Off"
# --------------------------------------------------------------------------

shortcuts run "$DND_OFF_SHORTCUT" >/dev/null 2>&1 || true

for url in "${TABS[@]}"; do
  open "$url" >/dev/null 2>&1 || true
done

open -a WezTerm >/dev/null 2>&1 || true
[[ "$OPEN_REMINDERS" == "true" ]] && open -a Reminders >/dev/null 2>&1 || true

/usr/bin/osascript -e "display notification \"Good morning. Everything's up.\" with title \"Morning Boot 🌅\"" >/dev/null 2>&1 || true
echo "Morning boot complete."
