#!/usr/bin/env bash
# name: Bedtime
# icon: 🌙
#
# Force the Mac to sleep after a fixed timer, no matter what's playing.
# Media players (Netflix, YouTube, IINA, ...) assert power locks to keep the
# screen awake during video, so an ordinary idle timer never fires. `pmset
# sleepnow` overrides those assertions, so this always wins.
#
# Trigger it, then put the Mac out of reach and drift off. Re-triggering
# resets the countdown. Use "Cancel Bedtime" if you're still awake.
#
# Lives here rather than in a fish function because it's macOS-only (pmset,
# osascript, Sol) and .config/sol/ only syncs on Darwin.

# Sol runs scripts via a non-login bash, so Homebrew's bin is not on PATH.
export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
MINUTES=60                 # how long until the Mac sleeps
WARN_MINUTES=5             # audible heads-up this many minutes before (0 = off)
# --------------------------------------------------------------------------

STATE_DIR="${TMPDIR:-/tmp}/sol-bedtime"
PIDFILE="$STATE_DIR/timer.pid"
mkdir -p "$STATE_DIR"

# Cancel any timer already running so triggering again just resets the clock.
if [[ -f "$PIDFILE" ]]; then
  OLD_PID="$(cat "$PIDFILE" 2>/dev/null)"
  if [[ -n "$OLD_PID" ]] && kill -0 "$OLD_PID" 2>/dev/null; then
    kill "$OLD_PID" 2>/dev/null
  fi
  rm -f "$PIDFILE"
fi

SECONDS_TOTAL=$(( MINUTES * 60 ))
WARN_SECONDS=$(( WARN_MINUTES * 60 ))

# Detached background timer: nohup + disown keeps it alive after Sol's shell
# exits, so the countdown survives even though the launcher has moved on.
nohup bash -c '
  TOTAL='"$SECONDS_TOTAL"'
  WARN='"$WARN_SECONDS"'
  if (( WARN > 0 && WARN < TOTAL )); then
    sleep $(( TOTAL - WARN ))
    /usr/bin/osascript -e "display notification \"Sleeping in '"$WARN_MINUTES"' min. Trigger Bedtime again to keep watching.\" with title \"Bedtime 🌙\" sound name \"Submarine\"" >/dev/null 2>&1 || true
    sleep "$WARN"
  else
    sleep "$TOTAL"
  fi
  # Best-effort pause (spacebar to frontmost app), then force sleep.
  /usr/bin/osascript -e "tell application \"System Events\" to key code 49" >/dev/null 2>&1 || true
  /usr/bin/pmset sleepnow >/dev/null 2>&1
  rm -f "'"$PIDFILE"'"
' >/dev/null 2>&1 &
disown
echo $! > "$PIDFILE"

/usr/bin/osascript -e "display notification \"Mac will sleep in $MINUTES minutes. Sweet dreams 😴\" with title \"Bedtime 🌙\"" >/dev/null 2>&1 || true
echo "Bedtime set: Mac will sleep in $MINUTES minutes."
