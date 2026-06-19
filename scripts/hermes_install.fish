#!/usr/bin/env fish

# Bootstrap Hermes Agent + mnemosyne memory from tracked dotfiles.
#
# Idempotent: safe to run repeatedly. Installs Hermes if missing, deploys the
# tracked config.yaml / SOUL.md, wires mnemosyne (provider mode) into Hermes's
# own venv, and verifies. Secrets (.env, auth.json) are NEVER touched here —
# run `hermes auth` / `hermes model` once per machine to provide credentials.

log "setting up Hermes Agent"

set -l hermes_home $HERMES_HOME

# 1. Install Hermes if the launcher is missing.
if not command -q hermes
    log "installing Hermes (not found on PATH)"
    if command -q curl
        curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
        or begin
            echo 'error: Hermes install failed'
            exit 1
        end
        fish_add_path $HOME/.local/bin
    else
        echo 'error: curl required to install Hermes'
        exit 1
    end
end

# 2. Deploy tracked config (never clobbers secrets / state).
rsync -a ./.config/hermes/config.yaml ./.config/hermes/SOUL.md $hermes_home/
or echo 'warning: failed to deploy Hermes config'

# 3. Resolve Hermes's own venv python (the mnemosyne provider imports
#    agent.memory_provider, which only resolves inside Hermes's venv).
set -l hermes_py
for candidate in \
        $hermes_home/hermes-agent/venv/bin/python \
        $hermes_home/venv/bin/python
    if test -x $candidate
        set hermes_py $candidate
        break
    end
end

# Fall back to parsing the launcher wrapper for the venv path.
if test -z "$hermes_py"
    set -l launcher (command -v hermes)
    if test -n "$launcher"
        set -l venv_hermes (string match -r '"([^"]+/bin)/hermes"' < $launcher | tail -1)
        set -l bindir (string replace -r '.*"([^"]+/bin)/hermes".*' '$1' (grep -o '"[^"]*/bin/hermes"' $launcher | head -1))
        if test -x "$bindir/python"
            set hermes_py "$bindir/python"
        end
    end
end

if test -z "$hermes_py"
    echo 'warning: could not locate Hermes venv python; skipping mnemosyne setup'
    echo 'done setting up Hermes'
    exit 0
end

# 4. Install mnemosyne into Hermes's venv (idempotent; --python targets the venv).
if not $hermes_py -c 'import mnemosyne_hermes' 2>/dev/null
    log "installing mnemosyne memory into Hermes venv"
    if command -q uv
        uv pip install --python $hermes_py "mnemosyne-hermes[all]"
        or echo 'warning: failed to install mnemosyne-hermes'
    else
        $hermes_py -m pip install "mnemosyne-hermes[all]"
        or echo 'warning: failed to install mnemosyne-hermes'
    end
end

# 5. Run the mnemosyne installer (creates the $HERMES_HOME/plugins/mnemosyne
#    discovery symlink + bootstraps deps). Idempotent with --force.
if $hermes_py -c 'import mnemosyne_hermes' 2>/dev/null
    log "wiring mnemosyne provider"
    $hermes_py -m mnemosyne_hermes.install install --force
    or echo 'warning: mnemosyne installer reported an issue'
end

# 6. memory.provider is already mnemosyne in the tracked config.yaml; verify.
log "verifying Hermes memory"
hermes memory status 2>/dev/null | grep -iE 'provider|mnemosyne|status' | head -5
or echo 'note: run `hermes memory status` to confirm mnemosyne is active'

echo 'done setting up Hermes'
