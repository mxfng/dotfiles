# Max's agent instructions

These are common instructions for Max's agents across all scenarios.

## General Guidelines

- Never use the em dash "-". Use the plain dash "-" instead.
- When writing commit messages, never auto-add your agent name as a co-author.
- Never manually modify `CHANGELOG.md` files or any files that are marked as auto-generated.
- When writing or substantially editing long Markdown files, preserve normal Markdown structure. Put each full sentence on its own line, but avoid wrapping multiple sentences onto one physical line.
- When making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long-term maintainability.
- When doing bug fixes, always start by reproducing the bug in an E2E setting, as closely aligned as possible with how an end user would experience it while end-to-end testing the product. This makes sure you find the real problem so your fix will actually solve it. If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness. If you see one, even if it is not caused by what you are working on right now, still get it fixed.

## Editing my dotfiles and configs

My shell, editor, terminal, window-manager, and agent configs under `~/.config/` (including `~/.config/agents/`), along with `~/AGENTS.md` at the home root, are deployed copies, not the source of truth. They come from my dotfiles repo at `~/Developer/dotfiles` and are copied into place by its `./sync` script.

- Edit the source in `~/Developer/dotfiles/`, then run `./sync` to deploy. Do not edit the deployed copy in `~/.config/` (or `~/AGENTS.md`, etc.) directly; the next sync overwrites it and the change is lost from version control.
- New config must be added to the repo's `sync` script to deploy, and a new `~/.config/` dir may need a `config_audit` allowlist entry. The repo's own `AGENTS.md` has the details.
- If you're unsure whether a path is managed by the repo, check whether it exists under `~/Developer/dotfiles/.config/` before editing in place.

## Max's Opinions

When you are working on something that would benefit from being informed by Max's viewpoints, read `~/.config/agents/OPINIONS.md` to understand them.

## Voice Profile

When you are talking or posting on behalf of Max using his identity, read `~/.config/agents/VOICE.md` to see how Max writes.
