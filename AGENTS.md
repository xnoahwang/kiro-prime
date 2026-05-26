# AGENTS.md

This file is for AI coding agents (Cursor, Claude Code, Codex, Continue, Aider, etc.) reading this repo to adapt it to a different IDE or tool.

## What this repo is

A user-level configuration installer for **Kiro IDE**. It writes one markdown file (`behavior.md`) into Kiro's steering folder so the behavior rules apply to every Kiro chat in every project.

The behavior rules are **tool-agnostic** — Plan Gate, Surgical Changes, Pre-flight File List, Verify Receipt, Edge Case Checklist, and Self-Review Delta Report all work with any LLM that respects a system prompt.

## What you should do

If the user asks you to adapt this repo for a different AI coding tool, do the following without asking for clarification on these steps:

1. Detect the host OS. The original `install.ps1` is Windows-only (PowerShell). For macOS or Linux, you must produce an equivalent `install.sh` (bash, posix-portable) and `uninstall.sh`. Do not delete the `.ps1` files — Windows users still need them.

2. Identify the target tool's user-level prompt path. Use the matrix below; `~` is the user's home (`%USERPROFILE%` on Windows, `C:\Users\noahw` on macOS/Linux).

   | Tool         | Path (all OSes use `~` form internally)          |
   |--------------|---------------------------------------------------|
   | Kiro         | `~/.kiro/steering/behavior.md`                    |
   | Cursor       | `~/.cursor/rules/behavior.mdc`                    |
   | Claude Code  | `~/.claude/CLAUDE.md`                             |
   | Continue     | `systemMessage` field in `~/.continue/config.json` |
   | Aider        | `~/.aider.conf.yml` `read:` entry                 |
   | Codex CLI    | `~/.codex/AGENTS.md`                              |

   If the target tool isn't listed, ask the user once for the correct path before proceeding. Do not guess.

2. In `install.ps1`, update the `$Files` array entry whose `Src` is `home\.kiro\steering\behavior.md` so its `Dst` becomes the new target path. Keep `Src` the same — the content of `behavior.md` does **not** need to change.

3. If the target uses JSON or YAML (Continue, Aider) instead of a plain markdown drop, `install.ps1` needs a different strategy: read the existing config, merge the behavior text into the correct field, write back. **Ask the user before doing this** — it's not a one-line change and risks corrupting their existing config.

4. Rename the project display name in `README.md` (e.g. `kiro-prime` → `cursor-prime`), update install URLs to point at the user's fork, but keep the LICENSE and the Karpathy-derived rules intact.

5. Verify:
   - Delete the target prompt file first (if any) so you have a clean state.
   - Run the patched `install.ps1`.
   - Confirm the file is at the new path.
   - Open the target tool and ask it to perform a non-trivial task.
   - Confirm Plan Gate triggers — the agent should output a `<plan>` block and wait for `GO`.

6. Show the user a Delta Report of every file you changed (per the Self-Review rule in `home/.kiro/steering/behavior.md`).

## OS adaptation (macOS / Linux)

If the host is not Windows, port the installer to bash:

- Translate `install.ps1` → `install.sh`:
  - shebang: `#!/usr/bin/env bash`
  - `C:\Users\noahw` → `C:\Users\noahw`
  - `Copy-Item src dst -Force` → `cp -f src dst`
  - `New-Item -ItemType Directory -Force` → `mkdir -p`
  - `Get-Date -Format 'yyyyMMdd-HHmmss'` → `date +%Y%m%d-%H%M%S`
  - `Set-Content -Encoding UTF8` → plain `cat > file`
  - `ConvertTo-Json -Depth 6` → `python3 -c` or `jq` to write JSON
  - Make it executable: `chmod +x install.sh uninstall.sh`
- Manifest path stays `~/.kiro-prime-manifest.json` and the JSON shape is unchanged, so a Windows user could (in theory) still uninstall a Linux install if they share the file. Don't break that.
- `git config --global core.excludesfile` is the same command on every OS — keep it.
- After porting, **run `install.sh` on the host** to verify it works end-to-end. Do not declare done from theory alone.

Keep both `install.ps1` and `install.sh` in the repo so the same fork serves both Windows and Unix users.

## What you should NOT do

- Do **not** modify `behavior.md` content. The rules are deliberately tool-agnostic; rewording "Kiro" → "Cursor" inside the rules is unnecessary and risks breaking Plan Gate's wording.
- Do **not** remove the manifest mechanism in `install.ps1` / `uninstall.ps1`. Keep the same shape so the fork stays cleanly uninstallable.
- Do **not** add network calls, telemetry, analytics, or any code that wasn't in the original.
- Do **not** change the licensing or remove the original attribution.

## Repo structure (for reference)

```
home/.kiro/steering/behavior.md   # the rules — keep as-is
home/.gitignore_global            # global gitignore — keep as-is
templates/                        # project-level init templates
install.ps1                       # path you need to edit
uninstall.ps1                     # picks up changes via manifest, no edit needed
init.ps1                          # project scaffolder, unaffected
README.md                         # rename + URL updates
AGENTS.md                         # this file — leave instructions intact
```

## Out of scope

- Pre-bundled macOS / Linux scripts in the upstream repo (they are produced on demand by following the OS adaptation steps above; the upstream stays Windows-first because that's what its author uses).
- Web UI, telemetry dashboards, or remote config.
- Per-project overrides — the file is meant to be user-level only.
