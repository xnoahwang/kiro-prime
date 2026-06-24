---
description: Instructions for AI agents to install or modify kiro-prime
alwaysApply: true
---

# AGENTS.md

This file is for AI coding agents reading this repo to **install kiro-prime** or adapt it to different platforms.

## Install kiro-prime (agent procedure)

When the user says something like *"install kiro-prime"* or *"set up kiro-prime"*, do ALL steps below autonomously. This is a straightforward installation — just execute and verify.

### Installation Steps

1. **Confirm location.** Verify you're in the `kiro-prime` repo root (contains `install.ps1`, `steering/`, `templates/`). If not, `cd` into it.

2. **Run the installer for the host OS.**
   
   **Windows:**
   ```powershell
   .\install.ps1
   ```
   
   Add `-Force` to overwrite existing installation.
   Add `-WithHooks` to install optional destructive operation guards.
   
   **macOS / Linux:**
   ```bash
   ./install.sh
   ```
   
   *(Note: Shell script version needs to be created by porting install.ps1 - see OS adaptation section)*

3. **What the installer does automatically:**
   - Copies `steering/behavior.md` → `~/.kiro/steering/behavior.md` (global rules)
   - Copies `templates/gitignore_global` → `~/.gitignore_global`
   - Configures git: `git config --global core.excludesfile ~/.gitignore_global`
   - Optional: Copies `hooks/guard-destructive.json` → `~/.kiro/hooks/` (with `-WithHooks`)
   - Creates `~/.kiro-prime-manifest.json` for clean uninstall

4. **Verify installation.**
   Check these files exist:
   - `~/.kiro/steering/behavior.md`
   - `~/.gitignore_global`
   - `~/.kiro-prime-manifest.json`
   
   Report PASS/FAIL with actual paths.

5. **Test the Plan Gate.**
   - Open any Kiro session in any project
   - Ask for a non-trivial task (e.g., "add a login form")
   - Confirm Kiro outputs a `<plan>` block and waits for "GO"
   - If Plan Gate doesn't trigger, check if `~/.kiro/steering/behavior.md` exists and contains the Plan Gate section

6. **Optional: Project-level setup.**
   Tell the user they can run `.\init.ps1` inside any project to add:
   - `.kiro/steering/project.md` - Project-specific context
   - `progress.md` - Milestone tracker
   - `.gitignore` - Project gitignore template

**Key difference from cursor-prime:** No manual steps required. Kiro's global steering works immediately after file copy.

## What is kiro-prime?

A configuration installer for **Kiro** that enforces disciplined coding practices:

- **Plan Gate**: Forces planning before code modification
- **Surgical Changes**: Minimizes modification scope
- **Pre-flight File List**: Declares all files upfront
- **Verify Receipt**: Requires proof of testing
- **Edge Case Checklist**: Forces error path consideration
- **Self-Review Delta Report**: Mandatory completion summary

The rules are tool-agnostic (adapted from Andrej Karpathy's practices) but delivered through Kiro's native steering mechanism.

## Why Kiro's architecture is superior

| Feature | cursor-prime | kiro-prime |
|---------|--------------|------------|
| Global rules | Manual UI paste (no file API) | File-based (`~/.kiro/steering/`) |
| Installation | 5 steps + manual paste | 1 automated step |
| Reliability | Version-dependent bug workaround | Native file system support |
| Per-project | Required (main mechanism) | Optional (enhancement) |
| Hooks | Custom PowerShell scripts | Native Kiro hook system |

Kiro's native global steering means kiro-prime can be 10x simpler than cursor-prime while being more reliable.

## OS Adaptation (macOS / Linux)

To port `install.ps1` → `install.sh`:

### PowerShell → Bash mappings:
- Shebang: `#!/usr/bin/env bash`
- `$env:USERPROFILE` → `$HOME`
- `Copy-Item src dst -Force` → `cp -f src dst`
- `New-Item -ItemType Directory -Force -Path dir` → `mkdir -p dir`
- `Test-Path path` → `[ -e path ]`
- `Get-Date -Format 'yyyyMMdd-HHmmss'` → `date +%Y%m%d-%H%M%S`
- `ConvertTo-Json` → `jq` or `python3 -c 'import json; ...'`

### Example bash install script structure:
```bash
#!/usr/bin/env bash
set -e

VERSION="0.1.0"
KIRO_DIR="$HOME/.kiro"
MANIFEST="$HOME/.kiro-prime-manifest.json"

# Create directories
mkdir -p "$KIRO_DIR/steering"

# Copy files
cp -f steering/behavior.md "$KIRO_DIR/steering/behavior.md"
cp -f templates/gitignore_global "$HOME/.gitignore_global"

# Configure git
git config --global core.excludesfile "$HOME/.gitignore_global"

# Write manifest (using jq or python)
echo '{"version":"'$VERSION'","files":["~/.kiro/steering/behavior.md","~/.gitignore_global"]}' > "$MANIFEST"

echo "✅ kiro-prime v$VERSION installed"
```

Make executable: `chmod +x install.sh init.sh uninstall.sh`

Port all three scripts (`install.ps1`, `init.ps1`, `uninstall.ps1`) and test end-to-end on the target OS.

## Repository Structure

```
kiro-prime/
├── steering/
│   └── behavior.md              # Core discipline rules (global)
├── templates/
│   ├── project.md               # Project context template
│   ├── progress.md              # Progress tracker template
│   ├── gitignore                # Project .gitignore
│   └── gitignore_global         # Global .gitignore
├── hooks/
│   └── guard-destructive.json   # Optional safety hook
├── install.ps1                   # Windows installer
├── init.ps1                      # Project initialization (optional)
├── uninstall.ps1                 # Clean removal
├── README.md                     # User documentation
├── AGENTS.md                     # This file (for AI agents)
├── LICENSE                       # MIT License
└── .gitignore                    # Repo .gitignore
```

## Verify Command

After installation, verify with:

```powershell
# Check files exist
Test-Path ~/.kiro/steering/behavior.md
Test-Path ~/.gitignore_global
Test-Path ~/.kiro-prime-manifest.json

# Check git config
git config --global core.excludesfile

# Test in Kiro
# Open any project, ask for non-trivial task, confirm Plan Gate triggers
```

## What NOT to do

- **Do NOT** change the core discipline rules' substance (they're tool-agnostic)
- **Do NOT** remove the manifest mechanism (enables clean uninstall)
- **Do NOT** add network calls, telemetry, or analytics
- **Do NOT** change licensing or remove attribution
- **Do NOT** make installation require manual UI steps (defeats Kiro's advantage)

## Troubleshooting

**Plan Gate not triggering:**
1. Verify `~/.kiro/steering/behavior.md` exists
2. Check file contains "## ⚠️ MANDATORY: Plan Gate" section
3. Restart Kiro if needed (steering loads at session start)

**Git config not applied:**
1. Run manually: `git config --global core.excludesfile ~/.gitignore_global`
2. Verify: `git config --global --get core.excludesfile`

**Hooks not working (with `-WithHooks`):**
1. Check `~/.kiro/hooks/guard-destructive.json` exists
2. Verify Kiro hooks are enabled in settings
3. Check Kiro version supports preToolUse hooks

## Out of Scope

- Web UI, remote config, telemetry
- Project scaffolding beyond templates (keep it minimal)
- Language-specific linting rules (use project `.kiro/steering/project.md` for that)

## Credits

- Rules adapted from **Andrej Karpathy**'s coding practices
- Inspired by **cursor-prime** architecture
- Built for **Kiro**'s superior global steering system
