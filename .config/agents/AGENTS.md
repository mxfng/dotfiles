# Max's agent instructions

## Writing

- Write in Simplified Technical English (ASD-STE100): short sentences, active voice, one idea per sentence, plain words.
- Never use the em dash (U+2014). Use a plain hyphen-minus "-" instead.

## Bugs

- Before fixing a bug, reproduce it end to end, the way a user would hit it.

## Machine

- macOS with Homebrew. GNU coreutils, findutils, sed, awk, tar and grep come before the BSD versions on PATH, so use GNU flags (`sed -i 's/a/b/'`, `stat -c`, `date -d`).
- Installed CLI tools: `rg`, `fd`, `bat`, `jq`, `gh`, `fzf`, `delta`, `ouch` (any archive format), `uv`, `ffmpeg`, `yt-dlp`, `psql`, `tailscale`.
- Language runtimes (node, pnpm, bun, go, python, ruby) come from asdf. Pin versions in the project's `.tool-versions`, not with Homebrew.

## Dotfiles

- `~/.config/`, `~/AGENTS.md` and `~/.claude/{settings.json,skills}` are deployed from `~/Developer/dotfiles`. Edit the source there and run `./sync`, never the deployed copy.
