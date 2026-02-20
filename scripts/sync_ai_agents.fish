#!/usr/bin/env fish

mkdir -p ~/.claude
rsync -aP ./.config/.claude/CLAUDE.md ~/.claude/CLAUDE.md
or exit 1
