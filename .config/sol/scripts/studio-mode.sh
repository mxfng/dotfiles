#!/usr/bin/env bash
# name: Studio Mode
# icon: 🎹
#
# Flip the Mac into music-making mode: launch Logic Pro, hush distractions,
# set a working volume, and give Logic its own aerospace workspace.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
WORKSPACE=4                # aerospace workspace to dedicate to Logic
VOLUME=70                  # output volume (0-100)
DND_ON_SHORTCUT="Do Not Disturb On"   # optional; see note at bottom
# --------------------------------------------------------------------------

notify() { /usr/bin/osascript -e "display notification \"$2\" with title \"$1\"" >/dev/null 2>&1 || true; }

# Pause Apple Music if it's playing so it doesn't fight your monitors.
/usr/bin/osascript -e 'tell application "System Events" to if (exists process "Music") then tell application "Music" to pause' >/dev/null 2>&1 || true

# Quiet notifications while tracking (no-op if you haven't made the Shortcut).
shortcuts run "$DND_ON_SHORTCUT" >/dev/null 2>&1 || true

/usr/bin/osascript -e "set volume output volume $VOLUME" >/dev/null 2>&1 || true

open -a "Logic Pro"

# Give Logic a moment to front, then move it to its own workspace.
sleep 2
aerospace move-node-to-workspace "$WORKSPACE" >/dev/null 2>&1 || true
aerospace workspace "$WORKSPACE" >/dev/null 2>&1 || true

notify "Studio Mode 🎹" "Logic up on workspace $WORKSPACE. Make something."
echo "Studio Mode on."
