# kiro-prime

User-level configuration for [Kiro](https://kiro.dev): Karpathy-derived coding rules, a strict Plan Gate, and a global `.gitignore`. One install, every project benefits.

## What it does

After install, every Kiro session in any project gets:

- **Plan Gate** — Kiro outputs a `<plan>` and waits for your `GO` before writing code on non-trivial tasks.
- **Karpathy rules** — surgical changes, simplicity first, terse responses, verifiable goals.
- **Global gitignore** — `__pycache__`, `node_modules`, `.venv`, IDE junk, and OS noise ignored across all repos.

## What it changes

Exactly three things on your machine. Nothing else:

| Path | Source |
|------|--------|
| `~/.kiro/steering/behavior.md` | `home/.kiro/steering/behavior.md` |
| `~/.gitignore_global` | `home/.gitignore_global` |
| `git config --global core.excludesfile` | set to `~/.gitignore_global` |

A manifest at `~/.kiro-prime-manifest.json` records what was installed so uninstall is precise.

## Requirements

- Windows 10 / 11
- PowerShell 5.1+ (built-in)
- Git
- Kiro IDE installed

(macOS / Linux support: see *Roadmap* below.)

## Install

```cmd
git clone https://github.com/<you>/kiro-prime %USERPROFILE%\kiro-prime
cd %USERPROFILE%\kiro-prime
.\install.ps1
```

To reinstall on top of an existing install: `.\install.ps1 -Force`

## Verify

Open a new Kiro chat in any folder and ask for a non-trivial task, e.g.:

> Write a Python CLI that downloads a URL and prints all `<a>` links grouped by domain.

Kiro should respond with a `<plan>` block and stop, waiting for `GO`. If it writes code immediately, Plan Gate didn't load — check `~/.kiro/steering/behavior.md` exists.

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

## Safety

- Existing files at install paths are preserved as `<file>.bak.<timestamp>` before being overwritten.
- Uninstall touches only files listed in `~/.kiro-prime-manifest.json`. Your other steering files are not touched.
- If you had `core.excludesfile` set before install, uninstall restores that value. Otherwise it unsets the key.
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
