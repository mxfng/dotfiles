---
name: pr-review
description: How to review someone else's pull request and post the review to GitHub. Governs verification depth (an escalation ladder from read-only up to headless browser testing), where comments go (inline on real lines, not a wall of top-level prose), and how the text reads (ASCII only, terse, no fluff). Use when asked to review a PR, look at someone's PR, leave comments on a PR, or approve a PR. Not for reviewing your own working diff - use code-review for that.
---

# pr-review

Reviewing someone's PR is writing to another person, in public, under Max's name.
Two failure modes matter: approving code you did not actually verify, and burying
a real finding in paragraphs nobody reads.
This skill fixes the depth of verification to the risk of the change, and fixes
the shape of the output to something a human can scan in ten seconds.

Read `~/.config/agents/VOICE.md` before writing any review text.

## Character set - hard rule

Type only characters that are directly reachable on a standard US keyboard.
That means printable ASCII and nothing else.

Banned, with the replacement to use:

| Banned | Use instead |
|---|---|
| em dash, en dash | plain dash `-` |
| curly quotes and apostrophes | `'` and `"` |
| ellipsis character | `...` |
| arrows | `->` |
| non-ASCII bullets | `-` |
| emoji | nothing |
| non-breaking space | a space |

This applies to every character you post: top-level bodies, inline comments,
suggested-change blocks, and commit messages you propose.
Before posting, grep the payload for anything outside ASCII and fix it:

```bash
grep -nP '[^\x00-\x7F]' review.json
```

An empty result is the gate. Do not post until it is empty.

## Step 1 - understand the change before judging it

```bash
gh pr view <n> --json title,body,author,files,additions,deletions,baseRefName
gh pr diff <n>
gh pr checks <n>
```

Read the PR body and any linked issue first.
Review against the intent the author stated, not against the change you would
have written.
If the intent is unstated or vague, that itself is the first comment.

## Step 2 - pick a verification tier

The single most common failure is assuming code is good because it reads well.
The second most common is running a full E2E suite on a typo fix.
Classify the change, then do exactly the work that tier calls for.

**Tier 1 - read only.**
Docs, comments, copy, formatting, test-only additions, config value tweaks,
patch-level dependency bumps, single-function changes fully covered by existing
tests.
Verification is: read the diff, confirm CI is green.
Do not check out the branch. Do not run anything.

**Tier 2 - trust CI, verify it covers the change.**
Any change to logic or behavior that has automated coverage.
Verification is: read the diff, then confirm from `gh pr checks` that the jobs
actually exercising this code path ran and passed.
Green CI is only evidence if a job touches the changed lines.
If nothing covers the new path, that is a missing-test comment, and you drop to
Tier 3 to verify by hand.

**Tier 3 - check out and exercise locally.**
Escalate here when any of these is true:

- the diff touches a shared module with three or more callers
- it changes a public API, wire format, schema, or migration
- it touches auth, permissions, money, concurrency, caching, retries, or
  anything that can lose or corrupt data
- it is a bug fix (reproduce the original bug on base, confirm the fix on head)
- the PR body specifies manual test steps
- CI is red, flaky, or does not cover the change
- Tier 1 or 2 turned up something you cannot resolve by reading

Verification is: `gh pr checkout <n>`, run the specified manual steps, and run
the relevant unit and E2E tests locally.
If the PR body specifies no steps, write your own and state them in the review
so the author can see what was and was not covered.

**Tier 4 - drive it in a headless browser.**
Escalate here only when the change is already Tier 3 AND it alters user-visible
web behavior that no automated test covers, or the PR claims a visual or
interaction fix you cannot confirm from code.
Use the `cloakbrowser` skill.
Do not open a browser to check a backend change.

### Escalation rules

- Start at the lowest tier the triggers permit, then escalate. Never start high
  "to be safe" - it costs real time and buries the actual findings.
- Escalation is one-way within a review. Once a trigger fires you do that tier's
  work; "it looked fine on second read" does not cancel it.
- Anything suspicious at any tier escalates one tier. Confusion is a trigger.
- If a tier is impossible - no local env, missing credentials, needs production
  data - say so explicitly in the review. Never let unverified read as verified.
  "Could not run the migration locally, no DB access, so I only read it" is a
  legitimate and useful thing to post.

## Step 3 - write the comments

**Comments belong on lines.**
Default to inline comments anchored to the exact line the problem is on.
A top-level paragraph describing a problem that lives on line 42 is worse than
the same sentence attached to line 42.
If you find yourself writing "in the handler, the retry loop..." then that is an
inline comment on the retry loop.

**Prefix each inline comment with its severity.**
Three levels, lowercase, nothing else:

- `blocking:` this must change before merge
- `question:` you need an answer to judge it
- `nit:` take it or leave it, author's call

Untagged comments make the author guess what is required, so tag every one.

**Use suggested changes for anything mechanical.**
A one-line fix belongs in a suggestion block the author can click, not in prose
describing the fix.

**One sentence per point.**
Say what is wrong and why it matters.
Do not restate the code back to the author - they wrote it.
Do not explain the general principle unless the specific instance is unclear.
Do not hedge with "maybe consider possibly" - if you are unsure, use
`question:` and ask the actual question.

**Compliments: sparingly, and only when earned.**
At most one per review, inline on the line that earned it, and only for a
non-obvious good decision - a clean solution to a hard problem, a test that
catches a case you would have missed, a simplification.
Praise for ordinary competent code is noise and devalues the real thing.

## Step 4 - the top-level comment

The rule scales with the verdict:

- **Clean, approving.** `LGTM` on its own is complete and correct.
  Add one clause only if the review needed real work to reach that verdict, e.g.
  `LGTM. Ran the migration locally against a copy of staging, came back clean.`
  Do not summarize the PR back to its author.
- **Nits only, approving.** One line pointing at them.
  `LGTM, couple of nits inline, none blocking.`
- **Requesting changes.** Two to four sentences, maximum. Name the blocking
  problem, point at where it is, stop. The detail lives inline.
- **Blocked on a question.** State the question and what it decides.

Never write a top-level comment that restates every inline comment.
Never open with praise as a cushion before the criticism.

## Step 5 - re-read before posting

Draft, then read the draft as the author would receive it.
Cut in this order:

1. Any sentence restating what the code does.
2. Any sentence explaining a principle the author obviously knows.
3. Hedges and qualifiers: "I think maybe", "it might be worth possibly".
4. Warmups and cushions: "Great work on this!", "Just a small thought".
5. Any point that would not change the code or the author's understanding.
6. Any non-ASCII character (run the grep above).

Then check the shape: paragraphs of more than three sentences get broken up or
cut. If a comment cannot be read in one pass, rewrite it shorter.

## Step 6 - post it

Inline comments require the reviews API, not `gh pr review`.
Write the payload to a file, grep it for non-ASCII, then post once:

```bash
cat > /tmp/review.json <<'EOF'
{
  "event": "REQUEST_CHANGES",
  "body": "Retry loop can double-charge on a 5xx. Details inline.",
  "comments": [
    {
      "path": "src/billing/charge.ts",
      "line": 42,
      "side": "RIGHT",
      "body": "blocking: this retries on any non-2xx, including a 500 that already committed the charge. Needs an idempotency key."
    },
    {
      "path": "src/billing/charge.ts",
      "start_line": 60,
      "line": 64,
      "side": "RIGHT",
      "body": "nit: this block reads cleaner as an early return."
    }
  ]
}
EOF

grep -nP '[^\x00-\x7F]' /tmp/review.json   # must print nothing

gh api --method POST repos/{owner}/{repo}/pulls/<n>/reviews --input /tmp/review.json
```

Notes:

- `event` is `APPROVE`, `REQUEST_CHANGES`, or `COMMENT`.
- `line` is the line number in the file at head, and it must fall inside the
  diff hunks or the API rejects the whole review.
- Use `start_line` plus `line` for a multi-line comment.
- Use `"side": "LEFT"` to comment on a deleted line.
- A clean approval with no inline comments is just:
  `gh pr review <n> --approve --body 'LGTM'`
- You cannot approve your own PR. If it is Max's own PR, post `COMMENT` instead
  and say so.

## What this skill is not

- Not a rubber stamp. `LGTM` is only correct after the tier's verification
  actually ran.
- Not a linter. If the repo has automated formatting or lint, do not hand-review
  what a tool already enforces.
- Not a rewrite request. Prefer small incremental fixes over "I would have
  structured this differently", unless the structure is the defect.
- Not for your own working diff. Use `code-review` for that, and `ship` for the
  pre-PR gate.
