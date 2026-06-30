#!/usr/bin/env bash
# name: Dev Layout
# icon: 🪟
#
# Open a coding workspace: nvim in WezTerm + a browser, tiled side by side on
# a dedicated aerospace workspace.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
WORKSPACE=2                          # aerospace workspace for dev work
PROJECT_DIR="$HOME/Developer"        # where nvim opens
BROWSER_URL="https://github.com"     # opens in your default browser
# --------------------------------------------------------------------------

# Switch first so new windows tile into this workspace.
aerospace workspace "$WORKSPACE" >/dev/null 2>&1 || true

# Editor: a fresh WezTerm window running nvim in the project dir.
open -na WezTerm --args start --cwd "$PROJECT_DIR" -- nvim . >/dev/null 2>&1 || \
  open -a WezTerm

# Browser (default handler).
open "$BROWSER_URL" >/dev/null 2>&1 || true

# Let the windows appear, then tidy the tiling into an even split.
sleep 1.5
aerospace flatten-workspace-tree >/dev/null 2>&1 || true
aerospace balance-sizes >/dev/null 2>&1 || true

/usr/bin/osascript -e "display notification \"nvim + browser on workspace $WORKSPACE.\" with title \"Dev Layout 🪟\"" >/dev/null 2>&1 || true
echo "Dev layout ready on workspace $WORKSPACE."
