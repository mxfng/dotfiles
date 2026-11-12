#!/usr/bin/env fish

# Toggle Google Calendar as a centered floating popup over whatever is on screen.
# Hidden state is a parking workspace; showing moves the window into the focused
# workspace, floats it, and centers it on the focused monitor.
# Calendar runs as a Helium --app window, so there is nothing to install per machine.
# Needs a ~1100px window, below that Calendar falls back to a clipped layout.
#
# Usage:
#   calendar_toggle.fish          # show if hidden or elsewhere, hide if visible here

set -l bundle net.imput.helium
set -l url https://calendar.google.com/calendar
set -l width 1100
set -l height 800
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

# Visible frame of the focused monitor as "x y w h" in top-left screen coordinates.
# AeroSpace reports the NSScreen index; AppKit's y axis is flipped relative to
# the accessibility coordinates used to position windows.
function focused_frame
    set -l idx (aerospace list-monitors --focused --format '%{monitor-appkit-nsscreen-screens-id}')
    osascript -l JavaScript -e "
        ObjC.import('AppKit');
        const s = \$.NSScreen.screens;
        const v = s.objectAtIndex($idx - 1).visibleFrame;
        const top = s.objectAtIndex(0).frame.size.height;
        [v.origin.x, top - v.origin.y - v.size.height, v.size.width, v.size.height].map(Math.round).join(' ')"
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
    exit 0
end

aerospace move-node-to-workspace --window-id $id $focused
aerospace layout --window-id $id floating
aerospace focus --window-id $id

set -l frame (string split ' ' -- (focused_frame))
set -l x (math round "$frame[1] + ($frame[3] - $width) / 2")
set -l y (math round "$frame[2] + ($frame[4] - $height) / 2")
osascript -e "
    tell application \"System Events\" to tell process \"Helium\"
        set w to first window whose name starts with \"Google Calendar\" and name does not end with \"Helium\"
        set position of w to {$x, $y}
        set size of w to {$width, $height}
    end tell" 2>/dev/null
exit 0
