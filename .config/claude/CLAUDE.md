# Dotfiles

Personal macOS dotfiles at ~/Developer/dotfiles. Synced via `./sync` (rsync-based), provisioned from scratch via `./provision`.
This file: .config/claude/CLAUDE.md → synced to ~/.claude/ via scripts/sync_ai_agents.fish

## Conventions
- Rose Pine Moon theme everywhere (nvim, wezterm, tmux, starship, vscode)
- Vim-style hjkl navigation everywhere (tmux, yabai, skhd)
- XDG Base Directory compliance (~/.config/)
- GNU tools on PATH over macOS BSD variants
- Fish shell with extensive abbreviations (~106), not aliases
- 2-space indentation across all configs

## Sync & Provisioning
- `./sync` — rsyncs .config/{fish,git,nvim,skhd,starship.toml,tmux,wezterm,yabai} + scripts/ + vscode settings
- `./provision` — full macOS setup: Homebrew, sync, shell, git-lfs, apps, defaults, window management, vscode extensions
- `scripts/sync_ai_agents.fish` — syncs .config/claude/CLAUDE.md to ~/.claude/

## Shell — Fish (.config/fish/)
- `conf.d/abbr.fish` — ~106 abbreviations (git, docker, kubectl, terraform, editors, etc.)
- `conf.d/variables.fish` — env vars: EDITOR=nvim, TERMINAL=wezterm, BROWSER=zen, XDG dirs, FZF config
- `conf.d/paths.fish` — GNU tools (coreutils, findutils, sed, tar, grep, awk) + local bins
- `conf.d/init_tools.fish` — initializes fzf, starship, zoxide
- `conf.d/tmux.fish` — auto-attaches to tmux "base" session on login
- `conf.d/theme.fish` — Rose Pine Moon fish theme
- `functions/fish_greeting.fish` — random quotes + system info on shell start
- `functions/restart_wm.fish` — restart yabai/skhd services

## Git (.config/git/config)
- Pager: delta (side-by-side diffs, line numbers)
- Pull: rebase mode
- Push: simple
- Default branch: main
- 26 aliases (amend, fixup, squash, flog, lol, lola, pfwl, puff, rum, fuckit, etc.)

## Neovim (.config/nvim/)
- Framework: LazyVim with default keymaps/options/autocmds (no overrides)
- Currently learning LazyVim defaults — prefer built-in keybindings over custom mappings
- Reference https://www.lazyvim.org/keymaps for default keybindings
- Colorscheme: Rose Pine (moon dark)
- Plugins: claudecode.nvim (<leader>a prefix), extra treesitter parsers (css, graphql, sql, etc.)
- Extras: fzf, eslint, prettier, typescript, json, tailwind, mini-hipatterns

## Terminal — WezTerm (.config/wezterm/)
- Rose Pine Moon, 70% opacity, macOS blur, font size 13
- Tab bar at bottom, hidden when single tab, minimal decorations

## Prompt — Starship (.config/starship.toml)
- Rose Pine color palette, nerd font symbols for 40+ language modules

## Tmux (.config/tmux/tmux.conf)
- Prefix: C-a
- Vi copy mode, mouse on, 50k scrollback
- Splits: | and _ (visual mnemonics)
- Navigation: hjkl pane focus, HJKL pane swap, C-hjkl resize
- Plugin: rose-pine/tmux (moon variant)
- Base index 1, renumber windows

## Window Management — Yabai + skhd (.config/yabai/ + .config/skhd/)
- Layout: BSP with 12px padding/gaps
- Modifier: cmd+alt for all shortcuts
- Focus: cmd+alt+hjkl, Move: shift+cmd+alt+hjkl, Resize: ctrl+cmd+alt+hjkl
- Workspaces: cmd+alt+1-9,0 (focus), shift+cmd+alt+1-9,0 (move window)
- Fullscreen: cmd+alt+z, Float toggle: cmd+alt+t

## VSCode (.config/code/)
- Theme: Rose Pine Moon, icons: Catppuccin Latte
- Font: JetBrains Mono 13, relative line numbers
- Neovim integration (vscode-neovim extension)
- Formatting: Prettier for web languages
- 18 extensions tracked in extensions.txt

## Scripts (scripts/)
- `sync_ai_agents.fish` — sync .config/claude/CLAUDE.md to ~/.claude/
- `vscode_install_extensions.fish` — install VSCode extensions from list
- `docker_setup_xdg.fish` — align Docker with XDG paths
- `fish_generate_completions.fish` — generate completions for asdf, docker, kubectl, etc.
- `macos_set_defaults.fish` — 30+ macOS defaults (keyboard, Finder, Dock, etc.)
- `skhd_fix_performance.fish` — set skhd to use /bin/bash for speed
- `yabai_setup_sa.fish` — passwordless sudo for yabai scripting addition
- `macos_install_show_active_workspace.fish` — active workspace indicator

## Brewfile
- 36 CLI tools (bat, fd, ripgrep, fzf, zoxide, neovim, gh, delta, asdf, k9s, terraform, etc.)
- 7+ casks (wezterm, vscode, raycast, zen, rancher, spotify, fonts)

## Other Tools
- Editor: nvim (primary), VSCode with neovim extension (secondary)
- Languages: TypeScript, Python, Go, Ruby (managed via asdf)
