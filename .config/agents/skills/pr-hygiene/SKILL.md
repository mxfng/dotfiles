---
name: pr-hygiene
description: Cleanup pass for a PR, before review and at merge. Removes comments that narrate the development process and prunes committed images to the final set. Use before opening a PR, after a review round that changed comments or images, and when merging a PR. Not a code review - it checks comments and assets, not logic.
---

# pr-hygiene

Run this pass twice: before review and at merge.
It removes residue from development: process comments and old screenshots.

## Before review

Read the full diff with `git diff <base>...HEAD`.
Check every comment that the change adds or modifies.

Keep a comment only if it states a constraint, invariant or external fact that the code cannot show.
Write it in one short sentence, in the style of the codebase.

Remove a comment if it contains:

- **History.** Review rounds, "per X", what the code did before, or abandoned approaches. Git and the PR keep the history.
- **Author and date stamps.** For example, `(Name, 2026-01-01)`. Git blame keeps this.
- **Notes for yourself or the reviewer.** Reminders, state tracking, justifications.

Shorten a comment if it is longer than one pass of reading.

Exception: a regression test can describe the old bug, because the bug is the reason for the test.
Write it as a rule ("X must Y"), not as a story ("X used to Z").

Images:

- Commit images only when the PR body needs them.
- Keep the minimum, usually one before/after pair.
- Delete old iterations, variants and images of reverted approaches.
- Cut any README that comes with the images to what a future reader needs.

Then run the format and lint checks and push.

## At merge

The person or agent that merges does this:

- Delete images and README text that review added and no longer needs.
- If several PRs merged in a row, clean their images in one pass.

The merge is not complete until this is done.

## Limits

- Do not review logic, names or design.
- Do not remove real documentation. If you are not sure, keep the comment and mention it in the PR body.
- Small PRs also need this pass.
