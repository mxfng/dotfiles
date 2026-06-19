#!/usr/bin/env fish

if not command -q hermes
    log "installing Hermes"
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
    or begin
        echo 'error: Hermes install failed'
        exit 1
    end
    fish_add_path $HOME/.local/bin
end

# TODO: Merge PR in hermes-claude-auth repo or remove from script scope
# Install hermes-claude-auth bypass (https://github.com/kristianvast/hermes-claude-auth)
# curl -fsSL https://raw.githubusercontent.com/kristianvast/hermes-claude-auth/main/install-remote.sh | bash

# Re-deploy tracked config over the default one the installer just wrote.
rsync -a ./.config/hermes/config.yaml ./.config/hermes/SOUL.md $HERMES_HOME/
or echo 'warning: failed to deploy Hermes config'

# Wire mnemosyne into Hermes's own venv (config.yaml sets memory.provider: mnemosyne).
set -l py $HERMES_HOME/hermes-agent/venv/bin/python
if not test -x $py
    echo 'warning: Hermes venv not found; skipping mnemosyne'
    exit 0
end
$py -c 'import mnemosyne_hermes' 2>/dev/null
or uv pip install --python $py 'mnemosyne-hermes[all]'
or $py -m pip install 'mnemosyne-hermes[all]'
$py -m mnemosyne_hermes.install install --force
or echo 'warning: mnemosyne wiring failed'
