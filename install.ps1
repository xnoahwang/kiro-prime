#Requires -Version 5.1
<#
.SYNOPSIS
    Install kiro-prime: user-level Kiro steering and global gitignore.

.DESCRIPTION
    Copies files from this repo's home/ folder into the user profile.
    Existing files are backed up to <file>.bak.<timestamp>. A manifest
    at ~/.kiro-prime-manifest.json records what was installed so
    uninstall.ps1 can undo precisely.

.PARAMETER Force
    Reinstall even if a manifest already exists.

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -Force
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$Repo         = $PSScriptRoot
$HomeDir      = $env:USERPROFILE
$ManifestPath = Join-Path $HomeDir '.kiro-prime-manifest.json'
$Timestamp    = Get-Date -Format 'yyyyMMdd-HHmmss'

function Log  ($m) { Write-Host "[kiro-prime] $m" -ForegroundColor Cyan }
function Warn ($m) { Write-Host "[kiro-prime] $m" -ForegroundColor Yellow }

# (source-relative-to-repo, destination-absolute) pairs.
# Add new files here to ship them via install.
$Files = @(
    @{ Src = 'home\.kiro\steering\behavior.md'; Dst = Join-Path $HomeDir '.kiro\steering\behavior.md' }
    @{ Src = 'home\.gitignore_global';          Dst = Join-Path $HomeDir '.gitignore_global'          }
)

if ((Test-Path $ManifestPath) -and -not $Force) {
    Warn "Already installed (manifest at $ManifestPath)."
    Warn "Run .\uninstall.ps1 first, or use -Force to reinstall."
    exit 1
}

# Validate all sources before touching anything
foreach ($f in $Files) {
    $src = Join-Path $Repo $f.Src
    if (-not (Test-Path $src)) { throw "Source missing: $src" }
}

$installedFiles = @()

foreach ($f in $Files) {
    $src = Join-Path $Repo $f.Src
    $dst = $f.Dst

    $dstDir = Split-Path $dst -Parent
    if (-not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    }

    $backup = $null
    if (Test-Path $dst) {
        $backup = "$dst.bak.$Timestamp"
        Copy-Item $dst $backup -Force
        Log "Backed up: $dst -> $backup"
    }

    Copy-Item $src $dst -Force
    Log "Installed: $dst"

    $installedFiles += [pscustomobject]@{ path = $dst; backup = $backup }
}

# Capture and update git core.excludesfile
$prevExcludes = git config --global --get core.excludesfile 2>$null
if (-not $prevExcludes) { $prevExcludes = $null }

$gitignoreGlobal = Join-Path $HomeDir '.gitignore_global'
git config --global core.excludesfile $gitignoreGlobal
Log "git config --global core.excludesfile = $gitignoreGlobal"

# Write manifest
$manifest = [pscustomobject]@{
    name         = 'kiro-prime'
    version      = '1.0.0'
    installed_at = (Get-Date).ToString('o')
    files        = $installedFiles
    git_config   = [pscustomobject]@{
        key      = 'core.excludesfile'
        set_to   = $gitignoreGlobal
        previous = $prevExcludes
    }
}

$manifest | ConvertTo-Json -Depth 6 | Set-Content -Path $ManifestPath -Encoding UTF8
Log "Manifest: $ManifestPath"

Log "Done. Open a new Kiro chat to verify Plan Gate is active."
