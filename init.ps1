#Requires -Version 5.1
<#
.SYNOPSIS
    Initialize a project with kiro-prime starter docs.

.DESCRIPTION
    Creates progress.md, .kiro\steering\project.md, and .gitignore in the
    current working directory. Existing files are never overwritten unless
    -Force is passed (in which case they are backed up to .bak.<timestamp>).

.PARAMETER Force
    Overwrite existing files; back them up first.

.EXAMPLE
    cd path\to\my\new\project
    & "$env:USERPROFILE\kiro-prime\init.ps1"

.EXAMPLE
    & "$env:USERPROFILE\kiro-prime\init.ps1" -Force
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$Repo      = $PSScriptRoot
$Target    = (Get-Location).Path
$Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Log  ($m) { Write-Host "[kiro-prime init] $m" -ForegroundColor Cyan }
function Skip ($m) { Write-Host "[kiro-prime init] $m" -ForegroundColor DarkGray }

# (template-name-in-repo, target-path-relative-to-cwd) pairs.
$Files = @(
    @{ Src = 'progress.md'; Dst = 'progress.md' }
    @{ Src = 'project.md';  Dst = '.kiro\steering\project.md' }
    @{ Src = 'gitignore';   Dst = '.gitignore' }
)

# Validate sources before touching anything
foreach ($f in $Files) {
    $src = Join-Path $Repo "templates\$($f.Src)"
    if (-not (Test-Path $src)) { throw "Template missing: $src" }
}

foreach ($f in $Files) {
    $src     = Join-Path $Repo "templates\$($f.Src)"
    $dstAbs  = Join-Path $Target $f.Dst
    $dstDir  = Split-Path $dstAbs -Parent

    if (-not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    }

    if (Test-Path $dstAbs) {
        if ($Force) {
            $backup = "$dstAbs.bak.$Timestamp"
            Copy-Item $dstAbs $backup -Force
            Copy-Item $src $dstAbs -Force
            Log "Replaced: $($f.Dst)  (backup: $(Split-Path $backup -Leaf))"
        } else {
            Skip "Skipped (exists): $($f.Dst)"
        }
    } else {
        Copy-Item $src $dstAbs -Force
        Log "Created:  $($f.Dst)"
    }
}

Log "Done in: $Target"
