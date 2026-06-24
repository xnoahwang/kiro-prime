# kiro-prime

A configuration installer for **Kiro** that enforces disciplined coding practices through systematic planning, verification, and self-review.

## What is kiro-prime?

kiro-prime delivers tool-agnostic discipline rules adapted from Andrej Karpathy's coding practices:
- **Plan Gate**: Forces planning before any code modification
- **Surgical Changes**: Minimizes scope of modifications
- **Pre-flight File List**: Declares all files to be touched upfront
- **Verify Receipt**: Requires proof of testing
- **Edge Case Checklist**: Forces consideration of error paths
- **Self-Review Delta Report**: Mandatory summary before completion

## Why Kiro?

Unlike other AI coding tools, Kiro has **native global steering** (`~/.kiro/steering/`), which means:
- ✅ Install once, applies to **all projects automatically**
- ✅ No manual UI pasting required
- ✅ No per-project setup needed (unless you want customization)
- ✅ Native hooks system for automation
- ✅ Reliable, file-based configuration

## Installation

### Quick Start (Recommended)

```powershell
# Clone and install
git clone https://github.com/yourusername/kiro-prime.git
cd kiro-prime
.\install.ps1
```

**That's it!** The Plan Gate now applies to every Kiro session.

### Advanced Options

```powershell
# Install with destructive operation guards
.\install.ps1 -WithHooks

# Force reinstall (overwrites existing)
.\install.ps1 -Force
```

### What Gets Installed

The installer automatically:
1. Copies core behavior rules to `~/.kiro/steering/behavior.md`
2. Sets up global gitignore at `~/.gitignore_global`
3. Configures git to use the global gitignore
4. Optionally installs guard hooks to `~/.kiro/hooks/` (with `-WithHooks`)
5. Creates a manifest at `~/.kiro-prime-manifest.json` for clean uninstall

**No manual steps required.** Open any project in Kiro and the rules apply immediately.

## Verify Installation

After installing, ask Kiro to perform any non-trivial task. You should see:
1. A `<plan>` block describing intended changes
2. Kiro waiting for you to type "GO"
3. After completion, a Delta Report summarizing changes

## Optional: Project-Level Customization

Most projects don't need this, but if you want project-specific configuration:

```powershell
# Inside your project directory
path\to\kiro-prime\init.ps1
```

This adds:
- `.kiro/steering/project.md` - Project-specific context
- `progress.md` - Milestone tracker
- `.gitignore` - Project gitignore starter

## Uninstall

```powershell
.\uninstall.ps1
```

Removes all files listed in the manifest. Your projects remain untouched.

## Project Structure

```
kiro-prime/
├── steering/
│   └── behavior.md              # Core discipline rules (global)
├── templates/
│   ├── project.md               # Project-specific context template
│   ├── progress.md              # Progress tracking template
│   ├── gitignore                # Project .gitignore template
│   └── gitignore_global         # Global .gitignore
├── hooks/
│   └── guard-destructive.json   # Optional safety hook
├── install.ps1                   # Global installation script
├── init.ps1                      # Optional project initialization
├── uninstall.ps1                 # Clean removal script
├── README.md                     # This file
└── LICENSE                       # MIT License
```

## The Rules

The core discipline enforced by kiro-prime:

### 1. Plan Gate (Mandatory)
Before **any** code modification:
- Output `<plan>` block
- List all files to be touched
- Wait for explicit "GO"

### 2. Surgical Changes
- Touch only what's needed
- No adjacent code modifications
- Remove only imports made unused by your changes

### 3. Verify Receipt
- Run actual commands
- Paste exact output
- No "tested and works" without proof

### 4. Edge Case Checklist
For each new function/endpoint, document:
- Empty/missing input behavior
- Malformed input behavior
- Error handling paths

### 5. Self-Review Delta Report
Before declaring done, output:
```
Delta Report
- Files changed: <path> (+lines / -lines)
- Outside plan: ⚠️ <if any>
- Signatures changed: <if any>
- Symbols deleted: <if any>
- Verify: <command> → <PASS/FAIL>
```

## Comparison with cursor-prime

| Feature | cursor-prime | kiro-prime |
|---------|--------------|------------|
| Global rules | Manual UI paste required | File-based, automatic |
| Per-project setup | Required | Optional |
| Installation steps | 5 + manual paste | 1 automated |
| Reliability | Version-dependent | Native file system |
| Hooks | Custom PowerShell | Native Kiro hooks |

kiro-prime leverages Kiro's superior architecture to deliver the same discipline with 10x less complexity.

## Requirements

- **Kiro** (AI coding environment with native steering support)
- **Git** (for global gitignore configuration)
- **Windows** (PowerShell scripts; macOS/Linux port coming soon)

## Contributing

kiro-prime is designed to be minimal and tool-agnostic. When contributing:
- Don't change the core discipline rules
- Don't add network calls or telemetry
- Keep installation simple and reversible
- Test end-to-end before submitting

## License

MIT License - see LICENSE file

## Credits

- Rules adapted from **Andrej Karpathy**'s coding practices
- Inspired by **cursor-prime**
- Built for **Kiro**'s superior steering architecture

## Support

- GitHub Issues: https://github.com/yourusername/kiro-prime/issues
- Kiro Discord: [link]
- Documentation: https://kiro.dev/docs
