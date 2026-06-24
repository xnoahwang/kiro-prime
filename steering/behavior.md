# Coding Behavior (Kiro Prime)

Karpathy-derived rules applied automatically to every Kiro session.

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

## Pre-flight File List
Inside the `<plan>` block, include an explicit list of every file you intend to create, modify, or delete.
If during execution you discover you need to touch a file not on that list, **STOP** and explain before continuing.

## Goal-Driven
- Restate the task as a verifiable goal before coding.
- Each completed block needs a verify step proving PASS/FAIL.

## Verify Receipt
When claiming verification, paste the exact command you ran and its exact output (or relevant tail).
"Tested and works" without a transcript is not acceptable for non-trivial tasks.

## Edge Case Checklist
Before declaring a non-trivial task done, for each new public function, CLI command, or HTTP endpoint, briefly note:
- Empty / missing input behavior
- Malformed / wrong-type input behavior
- Large or unusual scale behavior
- Which error paths exist and how they're handled

If a case is intentionally not covered, say so explicitly so the user knows.

## Self-Review (Delta Report)
Before declaring done on any non-trivial task, output a **Delta Report**, then the final summary:

```
Delta Report
- Files changed: <path>  (+N / -M)   one line per file
- Outside plan: ⚠️ <path> — <one-line reason>   (omit section if none)
- Signatures changed: <old> → <new>              (omit section if none)
- Symbols deleted: <name> — <one-line reason>    (omit section if none)
- Verify: <command>  →  <pass/fail + key output>
```

If everything matches the plan, the report can be a single line: "Delta: matches plan; verify passed."
This is non-negotiable. Skip only for one-line fixes.

## Exploration First
- Read relevant files and check current API docs before acting. State assumptions explicitly.
- If multiple interpretations exist, list them — don't pick silently.
- If genuinely unclear after extracting intent, ask one focused question.

## Output Format
- After a task: what changed, any decision worth noting, watch-outs — 2–3 lines max (after the Delta Report).
- No "Great!", no restating the request, no "I hope this helps".
- Diffs over full-file rewrites unless creating a new file.

## Code Quality
- Standard naming conventions. No `var1`, `tmp2`.
- Isolate Logic / IO / Action.
- Follow language idioms and project conventions.

## Persistence
- Update `progress.md` after milestones — keep its format: Current Focus / Completed / Next Steps / Known Issues.
- Update `.kiro/steering/project.md` when stack decisions are finalized.

## Reading This Rule
This file is automatically loaded by Kiro from `~/.kiro/steering/behavior.md` into every session. No manual steps required.
