#!/usr/bin/env bash
# name: Clean Slate
# icon: 🧹
#
# Shut the day down: quit every app except a small keep-list, then empty the
# Trash. Asks first, because it's quitting your apps.

export PATH="/opt/homebrew/bin:$PATH"

# --- config ---------------------------------------------------------------
# Apps to leave running. Match the names as they appear in the menu bar.
KEEP=("WezTerm" "Finder" "sol" "AeroSpace")
CLEAR_DOWNLOADS=false      # true: also move ~/Downloads contents to Trash
# --------------------------------------------------------------------------

# Confirm — this quits apps and may discard unsaved work.
if ! /usr/bin/osascript -e 'button returned of (display dialog "Quit all apps and empty the Trash?" buttons {"Cancel", "Clean"} default button "Cancel" with icon caution with title "Clean Slate")' 2>/dev/null | grep -q "Clean"; then
  echo "Cancelled."
  exit 0
fi

# Build a quoted AppleScript list of names to keep.
keep_list=""
for app in "${KEEP[@]}"; do keep_list+="\"$app\","; done
keep_list="${keep_list%,}"

/usr/bin/osascript <<EOF >/dev/null 2>&1 || true
tell application "System Events"
  set keepList to {$keep_list}
  repeat with p in (every application process whose background only is false)
    set pname to name of p
    if keepList does not contain pname and pname is not "Finder" then
      try
        tell application pname to quit
      end try
    end if
  end repeat
end tell
EOF

# Empty the Trash (no warning sound/dialog).
/usr/bin/osascript -e 'tell application "Finder" to empty trash' >/dev/null 2>&1 || true

if [[ "$CLEAR_DOWNLOADS" == "true" ]]; then
  /usr/bin/osascript -e 'tell application "Finder" to delete (every item of folder "Downloads" of home)' >/dev/null 2>&1 || true
fi

/usr/bin/osascript -e 'display notification "Apps closed, Trash emptied." with title "Clean Slate 🧹"' >/dev/null 2>&1 || true
echo "Clean slate."
