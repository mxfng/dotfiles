#!/usr/bin/env bash
# name: Cinema Mode
# icon: 🎬
#
# Settle in to watch: open your streaming sites, Do Not Disturb on, a
# comfortable volume, and the browser fullscreened on its own workspace.
# Pairs with Bedtime — trigger this, then Bedtime, and drift off.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
SITES=(
  "https://fmhy.net/video"
  "https://www.cineby.at/"
  "https://www.miruro.to/"
)
WORKSPACE=6                # aerospace workspace for the browser
VOLUME=50
FULLSCREEN=true
DND_ON_SHORTCUT="Do Not Disturb On"
# --------------------------------------------------------------------------

shortcuts run "$DND_ON_SHORTCUT" >/dev/null 2>&1 || true
/usr/bin/osascript -e "set volume output volume $VOLUME" >/dev/null 2>&1 || true

# Open the streaming sites in your default browser (last one is the active tab).
for url in "${SITES[@]}"; do
  open "$url" >/dev/null 2>&1 || true
done

# Let the browser come to front, then move IT (now the focused window) to the
# workspace and fullscreen it.
sleep 1.5
aerospace move-node-to-workspace "$WORKSPACE" >/dev/null 2>&1 || true
aerospace workspace "$WORKSPACE" >/dev/null 2>&1 || true
[[ "$FULLSCREEN" == "true" ]] && aerospace fullscreen on >/dev/null 2>&1 || true

/usr/bin/osascript -e "display notification \"Lights down. Enjoy the show 🍿\" with title \"Cinema Mode 🎬\"" >/dev/null 2>&1 || true
echo "Cinema mode on (workspace $WORKSPACE)."
