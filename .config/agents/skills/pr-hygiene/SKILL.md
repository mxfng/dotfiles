---
name: pr-hygiene
description: Entropy pass required before ANY PR is submitted for review, and the matching cleanup duty at merge time. Strips development-narrative comment fluff (review-round history, prose-crammed explanations, self-notes) from the diff and prunes committed image assets to the minimal final set. Use right before opening a PR, after any review round that touched comments or images, and when merging a PR (the merger runs or dispatches the asset cleanup). Not a code review - it judges comments and assets, not logic.
---

# pr-hygiene

PRs accumulate entropy while they are worked: comments that narrate the
development process instead of describing the code, and screenshot assets
committed for review reporting that outlive their purpose.
Both read as content but are actually residue.
This skill is the pass that removes them - once before review, once at merge.

## Phase 1 - before submitting any PR for review

Walk the ENTIRE diff (`git diff <base>...HEAD`), not just files you remember
touching, and judge every comment the change added or modified.

**The test: is this comment actually useful to another reader in six months?**

A comment fails the test when it is any of:

- **Change history.** Round numbers, review-cycle references, "per X's ruling",
  "since <issue> round N", descriptions of what the code USED to do or of
  superseded directions. Readers will not care what round it was.
  The PR, the spec issue, and git history hold the story.
  The comment says what the thing IS, not how it got there.
- **Prose-crammed.** Multi-sentence essays where a terse statement parses
  instantly. Shorten until it can be read in one pass.
  Keep only the constraint the code itself cannot show.
- **Self-useful only.** Notes that helped during development (state tracking,
  reminders, justification aimed at the reviewer) but are contextually
  irrelevant to the codebase going forward. Remove them entirely.

A comment passes when it states a non-obvious constraint, invariant, or
external fact the code cannot express, tersely, in the codebase's own idiom.

Two refinements learned in the field:

- **Date-stamped author credits are residue.** Bare `(Name, YYYY-MM-DD)` stamps
  embedded in comments fail the test the same way round numbers do - strip them.
  Provenance lives in git blame and the issue tracker.
- **Bug-fix before/after can be doctrine.** In a regression-guard test or a
  fix's concept doc, describing the old broken behavior IS the rationale for
  the guard's existence - keep it, but phrase the guard as a positive
  invariant ("X must Y") rather than a narration ("X used to Z").

**Images and docs assets.** Use discretion when committing image assets at
all. Before review: prune to the minimal set the PR body actually needs -
typically one final before/after pair. Delete every superseded iteration,
comparison variant, and reference image for directions that were reverted.
Trim any accompanying README to what a future reader needs.

Then re-run the repo's static gates (format/lint at minimum) and push.

## Phase 2 - at merge time (the merger's duty)

Whoever merges - a coordinator, or an agent it dispatches - does a final
sweep before or immediately after merging:

- Delete documentation images and README fluff that review no longer needs
  (review rounds often add assets after the Phase 1 pass ran).
- If several PRs merged in sequence, sweep their combined asset residue once.

The merge is not done until the residue is gone.

## What this skill is not

- Not a code review: logic, naming, and design are out of scope.
- Not a license to strip real documentation: doctrine comments, invariants,
  and non-obvious constraints stay. When unsure whether a comment is doctrine
  or residue, keep it and flag it in the PR body.
- Not optional for "small" PRs: entropy compounds fastest through many small
  merges.
