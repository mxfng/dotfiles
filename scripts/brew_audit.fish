#!/usr/bin/env fish

# Audit Homebrew drift between this machine and the tracked Brewfiles.
#
# Machines are intentionally not identical, so this is audit-only by default.
# Brewfile is the baseline for every machine; Brewfile.personal is added with --personal.
# Curated removal: `brew uninstall <name>...` the cruft, then `brew autoremove`.
#
# Usage:
#   brew_audit.fish                     # list drift in both directions
#   brew_audit.fish --personal          # also expect Brewfile.personal
#   brew_audit.fish [--personal] --purge  # uninstall everything not in the Brewfile(s)

set -gx HOMEBREW_NO_ENV_HINTS 1
set -l repo ~/Developer/dotfiles

# bundle cleanup and check take one file, so merge the ones in scope
set -l brewfile (mktemp)
cat $repo/Brewfile >$brewfile
contains -- --personal $argv; and cat $repo/Brewfile.personal >>$brewfile

if contains -- --purge $argv
    brew bundle cleanup --force --file $brewfile
    set -l code $status
    rm -f $brewfile
    exit $code
end

# Installed here but not in the Brewfile (cruft, or machine-specific apps).
set_color yellow
echo "installed but not in the Brewfile:"
set_color normal
set -l extra (brew bundle cleanup --file $brewfile 2>&1 \
    | string match -v -r '^(✔|Warning:|Would .brew cleanup|Would remove:|Run )')
test (count $extra) -eq 0; and echo "  (none)"; or printf '  %s\n' $extra

# In the Brewfile but missing here (under-provisioned machine).
set_color yellow
echo \n"in the Brewfile but missing here:"
set_color normal
if brew bundle check --file $brewfile >/dev/null 2>&1
    echo "  (none)"
else
    brew bundle check --verbose --file $brewfile 2>&1 \
        | string match -v -r '^(✔|Warning:)' | string replace -r '^' '  '
end

rm -f $brewfile
