#Requires -Version 5.1
<#
.SYNOPSIS
    Uninstall kiro-prime.

.DESCRIPTION
    Reads ~/.kiro-prime-manifest.json (written by install.ps1) and
    removes the files it installed. Restores the previous git
    core.excludesfile value, or unsets it if there was none.
    Backups created at install time are NOT touched unless
    -RestoreBackups is passed.

.PARAMETER RestoreBackups
    For each removed file, if a .bak.<timestamp> exists from install,
    rename it back into place.

.EXAMPLE
    .\uninstall.ps1

.EXAMPLE
    .\uninstall.ps1 -RestoreBackups
#>
[CmdletBinding()]
param(
    [switch]$RestoreBackups
)

$ErrorActionPreference = 'Stop'

$HomeDir      = $env:USERPROFILE
$ManifestPath = Join-Path $HomeDir '.kiro-prime-manifest.json'

function Log  ($m) { Write-Host "[kiro-prime] $m" -ForegroundColor Cyan }
function Warn ($m) { Write-Host "[kiro-prime] $m" -ForegroundColor Yellow }

if (-not (Test-Path $ManifestPath)) {
    Warn "Not installed (no manifest at $ManifestPath)."
    exit 0
}

$manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json

foreach ($f in $manifest.files) {
    if (Test-Path $f.path) {
        Remove-Item $f.path -Force
        Log "Removed: $($f.path)"
    }

    if ($f.backup -and (Test-Path $f.backup)) {
        if ($RestoreBackups) {
            Move-Item $f.backup $f.path -Force
            Log "Restored: $($f.path)  (from $($f.backup))"
        } else {
            Log "Backup kept: $($f.backup)"
        }
    }
}

# Restore git config
$key      = $manifest.git_config.key
$ourValue = $manifest.git_config.set_to
$prevVal  = $manifest.git_config.previous

$current = git config --global --get $key 2>$null
if (-not $current) { $current = $null }

if ($current -eq $ourValue) {
    if ($prevVal -and $prevVal -ne $ourValue) {
        git config --global $key $prevVal
        Log "Restored git $key = $prevVal"
    } else {
        git config --global --unset $key 2>$null | Out-Null
        Log "Unset git $key"
    }
}

Remove-Item $ManifestPath
Log "Uninstalled."
