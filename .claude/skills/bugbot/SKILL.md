---
name: bugbot
description: This skill should be used when the user asks to "find bugs in this PR", "run bugbot", "check this PR for bugs", "bug review", or wants bugs ranked by severity (critical/high/medium/low) across a pull request or diff.
version: 1.0.0
---

# Bugbot — PR Bug Finder

Spawn parallel sub-agents to hunt for bugs in the current PR diff, then synthesize their findings into a ranked report after ruling out false positives.

## Workflow

### Step 1: Get the diff

Retrieve the PR diff to establish scope:

```bash
# If on a branch with a GitHub PR:
gh pr diff

# Or against main:
git diff main...HEAD
```

### Step 2: Spawn parallel bug-finder agents

Launch multiple agents concurrently, each focused on a different bug category. Each agent receives the full diff and its specific lens.

Bug-finder lenses to run in parallel:

- **Logic & correctness** — off-by-one errors, wrong conditionals, incorrect return values, missed edge cases
- **Error handling** — unhandled exceptions, swallowed errors, missing null/undefined guards, bad fallbacks
- **Security** — injection vectors, auth bypass, insecure defaults, exposed secrets, improper input validation
- **Data integrity** — race conditions, incorrect mutations, state corruption, transaction gaps
- **Resource management** — leaks (memory, file handles, connections), missing cleanup, unbounded growth

Instruct each agent to return structured findings:

```
File: <path>
Line: <line or range>
Severity: critical | high | medium | low
Title: <one-line description>
Detail: <what's wrong and why it matters>
```

### Step 3: Review and rule out false positives

After all agents complete, go through every finding:

1. Read the surrounding code in the actual file (not just the diff) to verify the claim holds in full context.
2. Check whether the code path is reachable — dead code findings are false positives.
3. Look for mitigations already present elsewhere (e.g. upstream validation, framework guarantees).
4. Discard any finding you cannot independently confirm.

### Step 4: Write the final report

Output a single ranked report grouped by severity. Within each group, order by impact.

**Report format:**

```
## Bug Report — <branch or PR title>

### Critical
- [ ] **<Title>** (`<file>:<line>`)
  <One-sentence explanation of impact.>

### High
...

### Medium
...

### Low
...

---
_<N> confirmed bugs. <M> findings discarded as false positives._
```

If no confirmed bugs exist at a severity level, omit that section.

## Severity Definitions

| Severity | Meaning |
|----------|---------|
| Critical | Data loss, security breach, crash in production hot path |
| High | Incorrect behavior users will hit regularly |
| Medium | Edge case failure or degraded behavior |
| Low | Cosmetic, style, or hypothetical concern |

## Notes

- Err toward confirming only bugs you can clearly demonstrate from the code; if uncertain, downgrade severity rather than discard.
- Include line numbers so findings are actionable.
- Do not report style issues, missing tests, or refactor opportunities — bugs only.
