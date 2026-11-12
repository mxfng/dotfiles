#!/usr/bin/env fish

# Flip to Google Calendar on its own workspace, and back again.
# The Calendar window lives on a dedicated workspace (c) and fills it, so its
# desktop layout has all the room it needs. Pressing again returns to wherever
# you were. Calendar runs as a Helium --app window, so there is nothing to
# install per machine.
#
# Usage:
#   calendar_toggle.fish          # go to Calendar, or back if already there

set -l bundle net.imput.helium
set -l url https://calendar.google.com/calendar
set -l workspace c

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

if test (aerospace list-workspaces --focused) = $workspace
    aerospace workspace-back-and-forth
    exit 0
end

set -l found (find_calendar $bundle)
if test -z "$found"
    # Run the binary directly: `open --args` is ignored when Helium is already running
    command -q /Applications/Helium.app/Contents/MacOS/Helium
    or begin
        echo 'error: Helium not found' >&2
        exit 1
    end
    /Applications/Helium.app/Contents/MacOS/Helium --app=$url >/dev/null 2>&1 &
    disown
    for i in (seq 30)
        sleep 0.1
        set found (find_calendar $bundle)
        test -n "$found"; and break
    end
    test -n "$found"; or exit 1
end

set -l id (string split ' ' -- $found)[1]
set -l where (string split ' ' -- $found)[2]

if test "$where" != $workspace
    aerospace move-node-to-workspace --window-id $id $workspace
end
aerospace layout --window-id $id tiling 2>/dev/null
aerospace workspace $workspace
aerospace focus --window-id $id
exit 0
