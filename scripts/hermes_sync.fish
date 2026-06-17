#!/usr/bin/env fish

# Deploy tracked Hermes config into ~/.hermes/.
#
# Only copies config.yaml and SOUL.md. Never uses --delete and never touches
# secrets (.env, auth.json) or local state (state.db, sessions, mnemosyne DB,
# memories). Safe to run on a machine with an existing Hermes install.

set -l hermes_home $HOME/.hermes

mkdir -p $hermes_home

for file in config.yaml SOUL.md
    if test -f ./.hermes/$file
        rsync -a ./.hermes/$file $hermes_home/$file
        or echo "warning: failed to deploy .hermes/$file"
    end
end
