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

# TODO: This is a monkeypatch. Remove IF mnemosyne merges #366
# (https://github.com/AxDSan/mnemosyne/pull/366)
# Point mnemosyne's fastembed cache at $HERMES_HOME (upstream hardcodes ~/.hermes).
set -l emb (find $HERMES_HOME/hermes-agent/venv -path '*mnemosyne/core/embeddings.py')
test -n "$emb"; and not grep -q HERMES_HOME $emb
and perl -i -pe 's{os\.path\.expanduser\("~/\.hermes"\)}{os.environ.get("HERMES_HOME", os.path.expanduser("~/.hermes"))}' $emb

# TODO: Update hermes-claude-auth to respect HERMES_HOME value with #26
# (https://github.com/kristianvast/hermes-claude-auth/pull/26)
# Then re-introduce to script as automated step.
