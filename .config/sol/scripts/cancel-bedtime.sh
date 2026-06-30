#!/usr/bin/env bash
# name: Cancel Bedtime
# icon: ☀️
#
# Cancel a running Bedtime timer if you're still awake.

export PATH="/opt/homebrew/bin:$PATH"

STATE_DIR="${TMPDIR:-/tmp}/sol-bedtime"
PIDFILE="$STATE_DIR/timer.pid"

if [[ -f "$PIDFILE" ]]; then
  PID="$(cat "$PIDFILE" 2>/dev/null)"
  if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null; then
    kill "$PID" 2>/dev/null
    rm -f "$PIDFILE"
    /usr/bin/osascript -e "display notification \"Timer cancelled. Stay up as long as you like.\" with title \"Bedtime ☀️\"" >/dev/null 2>&1 || true
    echo "Bedtime timer cancelled."
    exit 0
  fi
  rm -f "$PIDFILE"
fi

echo "No bedtime timer was running."
