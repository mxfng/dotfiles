#!/usr/bin/env bash
# name: Deep Work
# icon: 🎧
#
# Kill the distractions: quit chat apps, turn on Do Not Disturb, start some
# focus audio, and run a session timer. The anti-distraction inverse of
# Bedtime.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
QUIT_APPS=("Slack" "Discord" "Messages" "Mail")
FOCUS_URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"  # lofi; opens in default browser
VOLUME=35
SESSION_MINUTES=50         # heads-up notification after this long (0 = off)
DND_ON_SHORTCUT="Do Not Disturb On"
# --------------------------------------------------------------------------

STATE_DIR="${TMPDIR:-/tmp}/sol-modes"
mkdir -p "$STATE_DIR"

shortcuts run "$DND_ON_SHORTCUT" >/dev/null 2>&1 || true

for app in "${QUIT_APPS[@]}"; do
  /usr/bin/osascript -e "tell application \"$app\" to quit" >/dev/null 2>&1 || true
done

/usr/bin/osascript -e "set volume output volume $VOLUME" >/dev/null 2>&1 || true
[[ -n "$FOCUS_URL" ]] && open "$FOCUS_URL" >/dev/null 2>&1 || true

# Session timer: detached so it fires after you've started working.
if (( SESSION_MINUTES > 0 )); then
  PIDFILE="$STATE_DIR/deep-work.pid"
  [[ -f "$PIDFILE" ]] && kill "$(cat "$PIDFILE")" 2>/dev/null
  nohup bash -c "
    sleep $(( SESSION_MINUTES * 60 ))
    /usr/bin/osascript -e 'display notification \"Time for a break. Stand up, look away.\" with title \"Deep Work 🎧\" sound name \"Glass\"' >/dev/null 2>&1
    rm -f '$PIDFILE'
  " >/dev/null 2>&1 &
  disown
  echo $! > "$PIDFILE"
fi

/usr/bin/osascript -e "display notification \"Heads down for $SESSION_MINUTES min.\" with title \"Deep Work 🎧\"" >/dev/null 2>&1 || true
echo "Deep work on."
