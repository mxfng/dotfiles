#!/usr/bin/env bash
# name: Studio Mode
# icon: 🎹
#
# Flip the Mac into music-making mode: launch Logic Pro, hush distractions,
# set a working volume, and give Logic its own aerospace workspace.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
WORKSPACE=1                # workspace to dedicate to Logic
EVAC_WORKSPACE=2           # existing workspace-1 windows get shoved here
VOLUME=70                  # output volume (0-100)
DND_ON_SHORTCUT="Do Not Disturb On"   # optional; see note at bottom
# --------------------------------------------------------------------------

notify() { /usr/bin/osascript -e "display notification \"$2\" with title \"$1\"" >/dev/null 2>&1 || true; }

# Pause Apple Music if it's playing so it doesn't fight your monitors.
/usr/bin/osascript -e 'tell application "System Events" to if (exists process "Music") then tell application "Music" to pause' >/dev/null 2>&1 || true

# Quiet notifications while tracking (no-op if you haven't made the Shortcut).
shortcuts run "$DND_ON_SHORTCUT" >/dev/null 2>&1 || true

/usr/bin/osascript -e "set volume output volume $VOLUME" >/dev/null 2>&1 || true

# Clear the target workspace: shove anything already there onto the evac one,
# but leave Logic put if it's already on workspace 1. Record what we move so
# Exit Studio Mode can put it back. State: line 1 = origin workspace, rest =
# evacuated window ids.
STATE_DIR="${TMPDIR:-/tmp}/sol-modes"
STATEFILE="$STATE_DIR/studio-evac.state"
mkdir -p "$STATE_DIR"
echo "$WORKSPACE" > "$STATEFILE"
while IFS='|' read -r wid app; do
  [[ -z "$wid" || "$app" == "Logic Pro" ]] && continue
  aerospace move-node-to-workspace --window-id "$wid" "$EVAC_WORKSPACE" >/dev/null 2>&1 || true
  echo "$wid" >> "$STATEFILE"
done < <(aerospace list-windows --workspace "$WORKSPACE" --format '%{window-id}|%{app-name}' 2>/dev/null)

open -a "Logic Pro"

# Give Logic a moment to front, then move it onto the now-empty workspace.
sleep 2
aerospace move-node-to-workspace "$WORKSPACE" >/dev/null 2>&1 || true
aerospace workspace "$WORKSPACE" >/dev/null 2>&1 || true

notify "Studio Mode 🎹" "Logic up on workspace $WORKSPACE. Make something."
echo "Studio Mode on."
