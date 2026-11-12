#!/usr/bin/env fish

# Print the upcoming agenda from the macOS Calendar database via icalBuddy.
# Google calendars show up there once the account is added in Internet Accounts,
# so there is no OAuth or API setup per machine.
#
# Usage:
#   calendar_agenda.fish              # rest of today plus the next 2 days
#   calendar_agenda.fish 6            # rest of today plus the next 6 days
#   calendar_agenda.fish --watch 3    # redraw every minute until interrupted

argparse w/watch -- $argv; or exit 1
set -l days 2
test (count $argv) -gt 0; and set days $argv[1]

command -q icalBuddy
or begin
    echo 'error: icalBuddy not found (brew install ical-buddy)' >&2
    exit 1
end

function agenda --argument-names days
    # -n: only events from now on. -nrd and -b '' keep rows compact. uniq collapses
    # the same all-day event appearing on several calendars (e.g. holidays).
    icalBuddy -n -sd -nrd -nc -npn \
        -iep title,datetime -po datetime,title -ps '|  |' \
        -df '%a %b %e' -tf '%H:%M' -b '' -ss '' \
        eventsToday+$days 2>&1 \
        | string replace -r '^(\S+\s+\S+\s+\d+):$' (set_color --bold)'$1'(set_color normal) \
        | string replace -a '|' '  ' \
        | uniq
end

if set -q _flag_watch
    while true
        clear
        agenda $days
        sleep 60
    end
else
    agenda $days
end
