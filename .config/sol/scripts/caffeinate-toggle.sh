#!/usr/bin/env bash
# name: Caffeinate
# icon: ☕
#
# Keep the Mac awake for a long download, render, or presentation. Trigger
# again to turn it off. The opposite of Bedtime.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
HOURS=0                    # 0 = stay awake indefinitely; otherwise N hours
# --------------------------------------------------------------------------

STATE_DIR="${TMPDIR:-/tmp}/sol-modes"
PIDFILE="$STATE_DIR/caffeinate.pid"
mkdir -p "$STATE_DIR"

# Already caffeinated? Toggle off.
if [[ -f "$PIDFILE" ]]; then
  PID="$(cat "$PIDFILE" 2>/dev/null)"
  if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null; then
    kill "$PID" 2>/dev/null
    rm -f "$PIDFILE"
    /usr/bin/osascript -e 'display notification "Mac can sleep normally again." with title "Caffeinate ☕"' >/dev/null 2>&1 || true
    echo "Caffeinate off."
    exit 0
  fi
  rm -f "$PIDFILE"
fi

# -dimsu: prevent display, idle, disk, and system sleep.
if (( HOURS > 0 )); then
  caffeinate -dimsu -t $(( HOURS * 3600 )) >/dev/null 2>&1 &
  MSG="Staying awake for $HOURS h."
else
  caffeinate -dimsu >/dev/null 2>&1 &
  MSG="Staying awake until you toggle off."
fi
disown
echo $! > "$PIDFILE"

/usr/bin/osascript -e "display notification \"$MSG\" with title \"Caffeinate ☕\"" >/dev/null 2>&1 || true
echo "Caffeinate on. $MSG"
