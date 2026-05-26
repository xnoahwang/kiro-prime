# kiro-prime

User-level configuration for [Kiro](https://kiro.dev): Karpathy-derived coding rules, a strict Plan Gate, and a global `.gitignore`. One install, every project benefits.

## Why use this?

- **Save credits.** Kiro plans before it codes, so you catch wrong directions *before* tokens are spent on wrong implementations. Real-world saves on non-trivial tasks: ~40%.
- **Karpathy discipline, automated.** Surgical changes, simplicity first, verifiable goals, terse output. No more "Great! Let me also refactor this for you" sprawl.
- **One config, every project.** Install once. Every Kiro chat in every folder picks it up.
- **Zero lock-in.** One uninstall command and your machine is back to how it was.

## How much does it save?

Concrete example. Same prompt, same model:

| Without kiro-prime | With kiro-prime |
|---|---|
| Kiro reads files, builds a venv, writes 200 lines, runs tests. You realize the approach is wrong, ask for a rewrite. | Kiro outputs a `<plan>`. You see it'd use `requests` when you wanted stdlib only. You correct it. Then GO. |
| ~2.4 credits | ~1.3 credits |

Trade-off, honestly: trivial tasks gain one extra round-trip (`<plan>` → `GO`). The rule allows Kiro to skip planning for one-line fixes. Net win is on real work.

## What it does

After install, every Kiro session in any project gets:

- **Plan Gate** — Kiro outputs a `<plan>` and waits for your `GO` before writing code on non-trivial tasks.
- **Karpathy rules** — surgical changes, simplicity first, terse responses, verifiable goals.
- **Global gitignore** — `__pycache__`, `node_modules`, `.venv`, IDE junk, and OS noise ignored across all repos.

The optional `init` command also drops starter docs (`progress.md`, project steering, project `.gitignore`) into any folder so Kiro has somewhere to write progress and project context.

## Requirements

- Windows 10 / 11
- PowerShell 5.1+ (built-in)
- Git
- Kiro IDE installed


## Install

### Option 1 — Ask Kiro to install (recommended)

Open any Kiro chat and paste this:

```
Install kiro-prime from https://github.com/xnoahwang/kiro-prime
Steps:
  1. git clone https://github.com/xnoahwang/kiro-prime %USERPROFILE%\kiro-prime
  2. cd %USERPROFILE%\kiro-prime
  3. run .\install.ps1
  4. summarize what changed
```

Kiro will think, output a `<plan>`, and stop. Read the plan, reply `GO`. Done.

To also scaffold project-level starter docs in your current project, follow up with:

```
Now run "& %USERPROFILE%\kiro-prime\init.ps1" in this project folder.
```

> ⚠️ You're letting Kiro run shell commands on your machine. Always read the `<plan>` before replying GO. The commands above are short and public — you can verify them by clicking the links.

### Option 2 — Manual (PowerShell)

```cmd
git clone https://github.com/xnoahwang/kiro-prime %USERPROFILE%\kiro-prime
cd %USERPROFILE%\kiro-prime
.\install.ps1
```

To reinstall on top of an existing install: `.\install.ps1 -Force`

## Verify

Open a new Kiro chat in any folder and ask for a non-trivial task, e.g.:

> Write a Python CLI that downloads a URL and prints all `<a>` links grouped by domain.

Kiro should respond with a `<plan>` block and stop, waiting for `GO`. If it writes code immediately, Plan Gate didn't load — check `~/.kiro/steering/behavior.md` exists.

## Initialize a project (optional)

After install, scaffold project-level starter docs in any project folder:

```cmd
cd path\to\your\project
& "%USERPROFILE%\kiro-prime\init.ps1"
```

Creates three files in the current directory:

| File | Purpose |
|------|---------|
| `progress.md` | Working log Kiro updates after milestones |
| `.kiro\steering\project.md` | Project-specific tech stack / commands (manual inclusion) |
| `.gitignore` | Project-specific ignores (secrets, runtime data, Kiro caches) |

Existing files are never overwritten without `-Force`. With `-Force`, they're backed up to `.bak.<timestamp>` first.

## What it changes on your machine

`install.ps1` touches exactly three things. Nothing else:

| Path | Source |
|------|--------|
| `~/.kiro/steering/behavior.md` | `home/.kiro/steering/behavior.md` |
| `~/.gitignore_global` | `home/.gitignore_global` |
| `git config --global core.excludesfile` | set to `~/.gitignore_global` |

A manifest at `~/.kiro-prime-manifest.json` records what was installed so uninstall is precise.

`init.ps1` only writes inside the project folder you run it from. It never touches anything outside.

## Customize

Edit `home/.kiro/steering/behavior.md` in this repo, then re-run `.\install.ps1 -Force`. Existing files at the install paths are backed up automatically.

You can drop additional steering files into `home/.kiro/steering/` — but you'll need to add them to the `$Files` list inside `install.ps1` so they get copied and tracked in the manifest.

## Update

```cmd
cd %USERPROFILE%\kiro-prime
git pull
.\install.ps1 -Force
```

## Uninstall

```cmd
cd %USERPROFILE%\kiro-prime
.\uninstall.ps1
```

This removes only the files recorded in the manifest. Backups created during install are kept untouched. To restore the pre-install state in one step:

```cmd
.\uninstall.ps1 -RestoreBackups
```

`init.ps1` has no uninstaller — it writes plain project files you own. Delete or edit them like any other file in your project.

## Safety

- `install.ps1` preserves existing files at install paths as `<file>.bak.<timestamp>` before overwriting.
- `uninstall.ps1` touches only files listed in `~/.kiro-prime-manifest.json`. Your other steering files are not touched.
- If you had `core.excludesfile` set before install, uninstall restores that value. Otherwise it unsets the key.
- `init.ps1` never overwrites without `-Force`.
- Scripts are short. Read them before running if you want.

## Push to your own GitHub

If you copied this repo locally and want it on your own account:

```cmd
cd %USERPROFILE%\kiro-prime
git remote set-url origin https://github.com/<you>/kiro-prime.git
git push -u origin main
```

## Scope

Windows-only. Built for personal use; shared in case it helps someone with the same setup. Cross-platform, package managers, and other niceties are out of scope — fork it if you need them.

## License

MIT — see [LICENSE](LICENSE).
