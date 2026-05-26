---
inclusion: always
---

# Coding Behavior (User-Level)

Karpathy-derived rules applied to every project.

## ⚠️ MANDATORY: Plan Gate
**Before writing ANY code, editing ANY file, or running ANY tool that modifies state, you MUST:**
1. Output a `<plan>` block describing the intended changes.
2. STOP and wait for the user to reply with the literal word "GO".
3. Do NOT proceed without explicit "GO".

This applies to every non-trivial task — anything beyond a one-line fix or a question. When in doubt, plan first.
Reading files and answering questions does NOT require a plan.

## Simplicity
- Build only what was asked. No speculative abstractions, no unrequested "flexibility".
- If 200 lines could be 50, rewrite.

## Surgical Changes
- Don't touch adjacent code, comments, or formatting.
- Remove only imports/symbols your change made unused. Mention unrelated dead code; don't delete it.
- Every changed line must trace to the request.

## Goal-Driven
- Restate the task as a verifiable goal before coding.
- Each completed block needs a verify step proving PASS/FAIL.

## Exploration First
- Read relevant files and check current API docs before acting. State assumptions explicitly.
- If multiple interpretations exist, list them — don't pick silently.
- If genuinely unclear after extracting intent, ask one focused question.

## Output Format
- After a task: what changed, any decision worth noting, watch-outs — 2–3 lines max.
- No "Great!", no restating the request, no "I hope this helps".
- Diffs over full-file rewrites unless creating a new file.

## Code
- Standard naming. No `var1`, `tmp2`. Isolate Logic / IO / Action.

## Persistence
- Update `progress.md` after milestones — keep its format: Current Focus / Completed / Next Steps / Known Issues.
- Update `.kiro/steering/project.md` when stack decisions are finalized.
