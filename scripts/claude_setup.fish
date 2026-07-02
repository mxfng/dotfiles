#!/usr/bin/env fish

# Install the Claude Code CLI (if missing) and Max's global skills.
# Provider selection and API keys are handled separately by `claude_use`.
# Usage:
#   ./scripts/claude_setup.fish   install the CLI and the pinned skill set

source (dirname (status filename))/../.config/fish/functions/log.fish

log "setting up Claude Code"

# Install the CLI via the official installer only when it isn't already present;
# the installer drops the binary in ~/.local/bin, which is already on PATH.
if not command -q claude
    echo 'installing Claude Code cli'
    curl -fsSL https://claude.ai/install.sh | bash
    or begin
        echo 'warning: failed to install Claude Code cli, skipping skills'
        exit 0
    end
end

# npx ships with node (via asdf); skip skills quietly if the toolchain is absent.
command -q npx
or begin
    echo 'warning: npx not found, skipping Claude Code skills'
    exit 0
end

# Global skills to keep installed, as `repo skill-name` pairs.
set -l skills \
    anthropics/skills skill-creator

log "setting up Claude Code skills"
for i in (seq 1 2 (count $skills))
    set -l repo $skills[$i]
    set -l skill $skills[(math $i + 1)]
    echo "installing $skill from $repo"
    npx --yes skills add $repo --skill $skill --global --yes
    or echo "warning: failed to install skill $skill"
end
