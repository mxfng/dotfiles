#!/usr/bin/env bash
# name: Cinema Mode
# icon: 🎬
#
# Settle in to watch: Do Not Disturb on, comfortable volume, and the front
# window fullscreened on its own workspace. Pairs with Bedtime — trigger this,
# then Bedtime, and drift off.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
WORKSPACE=6                # aerospace workspace for the player
VOLUME=50
DND_ON_SHORTCUT="Do Not Disturb On"
# --------------------------------------------------------------------------

shortcuts run "$DND_ON_SHORTCUT" >/dev/null 2>&1 || true
/usr/bin/osascript -e "set volume output volume $VOLUME" >/dev/null 2>&1 || true

# Move the focused (player) window to its workspace and fullscreen it.
aerospace move-node-to-workspace "$WORKSPACE" >/dev/null 2>&1 || true
aerospace workspace "$WORKSPACE" >/dev/null 2>&1 || true
aerospace fullscreen on >/dev/null 2>&1 || true

/usr/bin/osascript -e "display notification \"Lights down. Enjoy the show 🍿\" with title \"Cinema Mode 🎬\"" >/dev/null 2>&1 || true
echo "Cinema mode on (workspace $WORKSPACE)."
