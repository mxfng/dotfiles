---
name: ship
description: Pre-PR quality gate for the current change. Runs code review, security review, and end-to-end verification in sequence, self-corrects clear problems, escalates ambiguous product decisions, and reports whether the change is ready to open a PR. Use before opening a PR, or when asked to "ship", "ship it", or confirm a change is merge-ready. Do NOT use for reviewing an existing remote PR (use /review) or as a substitute for a single targeted review.
---

# ship

A pre-PR quality gate that sequences the review and verification skills already
available, so a change is validated end-to-end before it becomes a PR. This is a
gate, not an autopilot: it never merges, and it stops for a human on anything
with product implications.

## When to run

Run this when an implementation is believed complete and the next step is a PR.
Skip it for pure questions, throwaway spikes, or changes that touch only docs.

## Steps

Work through these in order. Do not skip a step because an earlier one looked
clean; each catches a different class of problem.

1. **Confirm there is something to ship.** Check `git status` and the working
   diff. If the tree is clean with nothing committed on this branch beyond the
   base, say so and stop, there is nothing to gate.

2. **Correctness review.** Run the `code-review` skill over the change at an
   effort level matching the risk (higher for logic-heavy or wide-reaching
   diffs). Collect its findings.

3. **Security review.** Run the `security-review` skill over the change. Collect
   its findings.

4. **End-to-end verification.** Run the `verify` skill to exercise the change the
   way a real user would, not just via unit tests. Capture concrete evidence the
   change does what it is supposed to (command output, a screenshot, a log), and
   note anything that did not behave as intended.

5. **Resolve and gate.**
   - Fix clear, unambiguous defects surfaced above yourself, then re-run the
     affected check to confirm the fix.
   - Escalate anything ambiguous or with product implications to the human with a
     crisp description and your recommendation. Do not guess on product intent.
   - Never open or merge the PR as part of this skill. This gate stops at
     "ready".

6. **Report.** Summarize: what changed, the findings from each review and how
   each was resolved, the verification evidence, an overall risk level
   (low / medium / high), and a clear verdict on whether it is ready for a PR.

## Notes

- Honor the global guidelines: reproduce and fix real end-user behavior over
  leaning on unit tests, and fix adjacent problems you notice along the way
  rather than stepping around them.
- Prefer fixing over reporting for anything unambiguous, but never trade away
  the human's call on genuine product decisions.
