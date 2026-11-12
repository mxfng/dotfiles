# dotfiles

Max's macOS dotfiles: fish, Neovim (LazyVim), WezTerm, tmux, Starship, AeroSpace.
All config lives under `.config/`, even when a tool needs a workaround.
Keep `~` and `~/.config/` clean.

## Layout

```
.config/      source of truth, deployed by ./sync
  agents/     AGENTS.md (-> ~/AGENTS.md, ~/.claude/CLAUDE.md), claude/settings.json, skills/
  fish/       conf.d/ runs at shell start; functions/ autoloads, one function per file
  nvim/ tmux/ wezterm/ aerospace/ git/ ssh/ starship.toml
  sol/        only config.json is synced; sol keeps runtime state beside it
scripts/      deployed to ~/Developer/scripts
provision     new-Mac bootstrap: brew bundle, sync, shell, apps
sync          deploys .config/ and scripts/
Brewfile      Homebrew packages
```

## sync

- It copies files. It never symlinks, so machines keep working without the repo.
- fish, nvim, tmux, wezterm, aerospace, git, ssh and scripts sync with `--delete`. A file removed from the repo is removed on the next sync.
- `~/.claude/skills/`, `~/.claude/settings.json`, `~/AGENTS.md` and sol sync without `--delete`. When you remove one of these from the repo, delete the deployed copy by hand.
- Add new config to `sync`. If a tool creates a `~/.config/` dir that the repo does not track, add it to the allowlist in `scripts/config_audit.fish`.

## Test a change

1. Run `./sync`. It must exit 0.
2. Check the deployed file, not the repo file.
3. For fish changes, test in a new shell: `fish -ic '<check>'`.
4. Run `./scripts/config_audit.fish`. It must report `~/.config/` clean.

Never run `./provision` on Max's main machine.

## Fish style

All scripts are fish. Match the existing files. These rules are not obvious from the code:

- A script starts with `#!/usr/bin/env fish`, then a comment: one line on what it does, then a `# Usage:` block.
- Find the repo with `(dirname (status filename))`. Source helpers from `.config/fish/functions/`: `log` for section headers, `confirm` for prompts.
- Messages are lowercase. Fatal error: `echo 'error: ...' >&2; exit 1`. Failed optional step: `echo 'warning: ...'`, then continue.
- Guard optional tools with `command -q`. Quote variables in `test`.
- Scripts are safe to run again. A destructive action needs an explicit flag.
