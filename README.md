# kiro-prime

User-level configuration for [Kiro](https://kiro.dev): Karpathy-derived coding rules, a strict Plan Gate, and a global `.gitignore`. One install, every project benefits.

## What it does

After install, every Kiro session in any project gets:

- **Plan Gate** — Kiro outputs a `<plan>` and waits for your `GO` before writing code on non-trivial tasks.
- **Karpathy rules** — surgical changes, simplicity first, terse responses, verifiable goals.
- **Global gitignore** — `__pycache__`, `node_modules`, `.venv`, IDE junk, and OS noise ignored across all repos.

The optional `init` command also drops starter docs (`progress.md`, project steering, project `.gitignore`) into any folder so Kiro has somewhere to write progress and project context.

## What it changes

`install.ps1` touches exactly three things on your machine. Nothing else:

| Path | Source |
|------|--------|
| `~/.kiro/steering/behavior.md` | `home/.kiro/steering/behavior.md` |
| `~/.gitignore_global` | `home/.gitignore_global` |
| `git config --global core.excludesfile` | set to `~/.gitignore_global` |

A manifest at `~/.kiro-prime-manifest.json` records what was installed so uninstall is precise.

`init.ps1` only writes inside the project folder you run it from. It never touches anything outside.

## Requirements

- Windows 10 / 11
- PowerShell 5.1+ (built-in)
- Git
- Kiro IDE installed

(macOS / Linux support: see *Roadmap* below.)

## Install

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

## Roadmap

- macOS / Linux install script (`install.sh`)
- Optional symbolic-link mode (edit-once, propagate)
- Per-language steering packs (Python, TypeScript, Go) as opt-in extras

## License

MIT — see [LICENSE](LICENSE).
