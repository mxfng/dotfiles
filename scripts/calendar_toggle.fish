#!/usr/bin/env fish

# Toggle Google Calendar as a fixed-width sidebar tiled at the right edge.
# Hidden state is a parking workspace; showing moves the window into the focused
# workspace (new windows land at the end of the root container) and pins its width.
# Calendar runs as a Helium --app window, so there is nothing to install per machine.
#
# Usage:
#   calendar_toggle.fish          # show if hidden or elsewhere, hide if visible here

set -l bundle net.imput.helium
set -l url https://calendar.google.com/calendar
set -l width 560
set -l parking c

# The app window shares Helium's bundle id with normal windows. Its title has no
# " - Helium" suffix, which tells it apart from a regular tab showing Calendar.
function find_calendar --argument-names bundle
    for line in (aerospace list-windows --all --format '%{window-id}|%{workspace}|%{app-bundle-id}|%{window-title}')
        set -l f (string split -m 3 '|' -- $line)
        test "$f[3]" = "$bundle"; or continue
        string match -q 'Google Calendar*' -- $f[4]; or continue
        string match -q '* - Helium' -- $f[4]; and continue
        echo $f[1] $f[2]
        return 0
    end
    return 1
end

set -l focused (aerospace list-workspaces --focused)
set -l found (find_calendar $bundle)
set -l launched false

if test -z "$found"
    # Run the binary directly: `open --args` is ignored when Helium is already running
    command -q /Applications/Helium.app/Contents/MacOS/Helium
    or begin
        echo 'error: Helium not found' >&2
        exit 1
    end
    /Applications/Helium.app/Contents/MacOS/Helium --app=$url >/dev/null 2>&1 &
    disown
    set launched true
    for i in (seq 30)
        sleep 0.1
        set found (find_calendar $bundle)
        test -n "$found"; and break
    end
    test -n "$found"; or exit 1
end

set -l id (string split ' ' -- $found)[1]
set -l where (string split ' ' -- $found)[2]

if test "$where" = "$focused" -a "$launched" = false
    aerospace move-node-to-workspace --window-id $id $parking
else
    aerospace move-node-to-workspace --window-id $id $focused
    aerospace focus --window-id $id
end
aerospace resize --window-id $id width $width 2>/dev/null
exit 0
