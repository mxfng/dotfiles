# dotfiles

Instructions for coding agents working in this repository.

## What this is

Max's personal dotfiles for macOS and Linux: fish shell, Neovim, WezTerm, tmux,
Starship, AeroSpace (macOS tiling WM), and Hyprland/rofi/waybar (Linux).
The guiding principle is root cleanliness via XDG: configuration lives under
`.config/`, forced into `.config/` whenever it mostly suits, even when awkward.

## Repository layout

```
.config/          XDG configs, the source of truth for everything synced
  agents/         Max's global cross-project agent instructions (deployed to ~ by sync)
  fish/           shell config; functions/ is autoloaded, one function per file
  nvim/ tmux/ wezterm/ starship.toml   editor and terminal
  aerospace/      macOS tiling WM
  hypr/ rofi/ waybar/                  Linux desktop
  sol/ colima/    tools that also store runtime state (synced surgically)
scripts/          helper scripts, deployed to ~/Developer/scripts
  config_audit.fish   flags untracked dirs in ~/.config against an allowlist
provision         macOS bootstrap: brew bundle, sync, shell, apps
provision-linux   Arch/Debian bootstrap
sync              rsync .config/* into ~/.config and refresh scripts
Brewfile          macOS packages
```

## Terminology

- **Sync** - `./sync` rsyncs selected `.config/*` trees into `~/.config/` (and
  scripts into `~/Developer/scripts/`). Deployment is copy-based, not symlinked,
  so the machine keeps working if this repo is moved or removed.
- **Provision** - one-time machine bootstrap (`./provision` on macOS) that
  installs packages, runs `sync`, and sets up the shell and apps.
- **Config audit** - `scripts/config_audit.fish` compares `~/.config/` against
  the tracked `.config/*` dirs plus a manual allowlist and flags strays.

## How it works

### sync (deployment)

`sync` is the heart of the repo. It rsyncs a hand-picked set of `.config`
subtrees into `~/.config/` (with `--delete` for fully-managed trees, and
surgical single-file copies for tools that keep runtime state alongside config,
e.g. `sol`, `colima`). It also deploys `.config/agents` to the home root and
runs `config_audit` at the end. Copy-based on purpose: no symlinks back into the
repo.

### fish functions

`.config/fish/functions/` is autoloaded: each file defines one function matching
its filename (e.g. `agents_init.fish`). Shared helpers like `log` and `confirm`
are sourced by scripts as needed. `agents_init` scaffolds an AGENTS.md +
CLAUDE.md symlink pair in any project repo.

## End-to-end testing

Changes to `.config` are not live until deployed. To verify a change the way the
machine actually consumes it:

1. Run `./sync` and confirm it exits 0 with no rsync errors.
2. Inspect the deployed target (e.g. `~/.config/fish/...`) rather than the repo
   source.
3. For shell changes, open a fresh fish session so autoloaded functions and
   config reload.
4. Confirm `config_audit` reports `~/.config/` clean (sync runs it with
   `--quiet`; run `./scripts/config_audit.fish` directly to see the report).

For a full machine bootstrap, test `./provision` on a throwaway environment, not
your primary machine.

## Conventions

- Keep the home root and `~/.config/` clean: new config belongs under `.config/`
  in the repo and must be added to `sync` to deploy. If a new `~/.config/` dir is
  expected but not tracked here, add it to the `config_audit` allowlist.
- Deployment is copy-based; do not introduce symlinks from `~` back into the repo
  unless a specific case requires it.

### Fish scripting style

All scripting in this repo is fish, not bash. Match the existing house style:

Structure:
- Standalone scripts start with `#!/usr/bin/env fish`. Functions live one-per-file
  in `.config/fish/functions/`, named to match the file; they are autoloaded.
- A script that needs its own directory does `cd (dirname (status filename))`; one
  that needs a helper sources it by the same relative anchor, e.g.
  `source (dirname (status filename))/../.config/fish/functions/log.fish`.
- Lead a script with a comment block: one line on what it does, then a `# Usage:`
  block showing each invocation and flag. Comment the why, not the what (see the
  GNU-tools note in `conf.d/paths.fish`).
- `conf.d/` files run at every shell start; guard interactive-only logic with
  `if status is-interactive`.

Output and errors:
- Use the `log` helper (blue `==> ` prefix) for top-level progress or section
  headers, and plain `echo` for detail lines. Prompt with the `confirm` helper.
- Use `set_color yellow` / `set_color normal` to highlight audit findings.
- Messages are lowercase. Aborting errors go `echo 'error: ...' >&2` then `exit 1`;
  non-fatal problems in optional steps `echo 'warning: ...'` and continue.

Idioms:
- Guard external commands with `command -q foo` before calling them.
- Prefer `and`/`or` connectors over nested `if` for short conditional chains, and
  `command; or exit 1` to fail fast after critical steps. Group with `begin/end`.
- Parse flags with `argparse` (or a `switch` loop for richer scripts, as in
  `config_audit.fish`); take positionals via `--argument-names`.
- Scope with `set -l` (local), `set -gx` (exported), `set -U` (universal); unset
  with `set -e`. Always quote variables in tests: `test -z "$x"`.
- Reach for fish builtins (`string`, `contains --`, `fish_add_path`) over shelling
  out to coreutils.

Safety:
- Scripts are idempotent and safe to re-run (`mkdir -p`, existence checks first).
- Default to non-destructive: audits report by default and only mutate behind an
  explicit `--clean`/`--purge`/`--force` flag.
