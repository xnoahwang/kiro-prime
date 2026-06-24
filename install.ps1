#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Global installation script for kiro-prime.

.DESCRIPTION
    Installs kiro-prime discipline rules and configuration globally for Kiro.
    - Copies behavior.md to ~/.kiro/steering/ (automatically loaded in all projects)
    - Sets up global gitignore
    - Optionally installs safety hooks
    - Creates manifest for clean uninstall

.PARAMETER Force
    Overwrite existing installation without prompting.

.PARAMETER WithHooks
    Install optional destructive operation guard hooks.

.EXAMPLE
    .\install.ps1
    Basic installation with core rules.

.EXAMPLE
    .\install.ps1 -WithHooks
    Install with safety hooks enabled.

.EXAMPLE
    .\install.ps1 -Force
    Reinstall, overwriting existing files.
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$WithHooks
)

$ErrorActionPreference = 'Stop'
$Version = '0.1.0'

# Paths
$RepoRoot = $PSScriptRoot
$UserHome = $env:USERPROFILE
$KiroDir = Join-Path $UserHome '.kiro'
$KiroSteeringDir = Join-Path $KiroDir 'steering'
$KiroHooksDir = Join-Path $KiroDir 'hooks'
$ManifestPath = Join-Path $UserHome '.kiro-prime-manifest.json'

Write-Host "kiro-prime installer v$Version" -ForegroundColor Cyan
Write-Host ""

# Check if Kiro directory exists
if (-not (Test-Path $KiroDir)) {
    Write-Host "WARNING: Kiro directory not found at: $KiroDir" -ForegroundColor Yellow
    Write-Host "Creating directory structure..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $KiroSteeringDir -Force | Out-Null
    if ($WithHooks) {
        New-Item -ItemType Directory -Path $KiroHooksDir -Force | Out-Null
    }
}

# Check for existing installation
if ((Test-Path $ManifestPath) -and -not $Force) {
    $existing = Get-Content $ManifestPath -Raw | ConvertFrom-Json
    Write-Host "WARNING: kiro-prime v$($existing.version) is already installed." -ForegroundColor Yellow
    Write-Host "Use -Force to overwrite or run uninstall.ps1 first." -ForegroundColor Yellow
    exit 1
}

# Backup existing files if Force is used
if ($Force -and (Test-Path $ManifestPath)) {
    Write-Host "Backing up existing installation..." -ForegroundColor Yellow
    $BackupDir = Join-Path $UserHome ".kiro-prime-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    
    $existing = Get-Content $ManifestPath -Raw | ConvertFrom-Json
    foreach ($file in $existing.files) {
        $expandedPath = [System.Environment]::ExpandEnvironmentVariables($file)
        if (Test-Path $expandedPath) {
            $dest = Join-Path $BackupDir (Split-Path $expandedPath -Leaf)
            Copy-Item $expandedPath $dest -Force
        }
    }
    Write-Host "  Backup created at: $BackupDir" -ForegroundColor Gray
}

# Installation steps
$InstalledFiles = @()

Write-Host "Installing kiro-prime..." -ForegroundColor Cyan

# 1. Copy core behavior rules
$BehaviorSrc = Join-Path $RepoRoot 'steering\behavior.md'
$BehaviorDst = Join-Path $KiroSteeringDir 'behavior.md'
Write-Host "  [1/4] Installing behavior rules..." -ForegroundColor Gray
Copy-Item $BehaviorSrc $BehaviorDst -Force
$InstalledFiles += '~/.kiro/steering/behavior.md'
Write-Host "    OK: $BehaviorDst" -ForegroundColor Green

# 2. Set up global gitignore
$GitignoreSrc = Join-Path $RepoRoot 'templates\gitignore_global'
$GitignoreDst = Join-Path $UserHome '.gitignore_global'
Write-Host "  [2/4] Setting up global gitignore..." -ForegroundColor Gray
Copy-Item $GitignoreSrc $GitignoreDst -Force
$InstalledFiles += '~/.gitignore_global'

try {
    git config --global core.excludesfile $GitignoreDst
    Write-Host "    OK: $GitignoreDst (configured in git)" -ForegroundColor Green
} catch {
    Write-Host "    OK: $GitignoreDst (git config failed, manual setup needed)" -ForegroundColor Yellow
}

# 3. Optional: Install hooks
if ($WithHooks) {
    Write-Host "  [3/4] Installing safety hooks..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $KiroHooksDir -Force | Out-Null
    
    $HookSrc = Join-Path $RepoRoot 'hooks\guard-destructive.json'
    $HookDst = Join-Path $KiroHooksDir 'guard-destructive.json'
    Copy-Item $HookSrc $HookDst -Force
    $InstalledFiles += '~/.kiro/hooks/guard-destructive.json'
    Write-Host "    OK: $HookDst" -ForegroundColor Green
} else {
    Write-Host "  [3/4] Skipping hooks (use -WithHooks to enable)" -ForegroundColor Gray
}

# 4. Write manifest
Write-Host "  [4/4] Writing installation manifest..." -ForegroundColor Gray
$Manifest = @{
    version = $Version
    installedAt = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')
    installedBy = $env:USERNAME
    withHooks = $WithHooks.IsPresent
    files = $InstalledFiles
} | ConvertTo-Json -Depth 3

Set-Content -Path $ManifestPath -Value $Manifest -Encoding UTF8
Write-Host "    OK: $ManifestPath" -ForegroundColor Green

Write-Host ""
Write-Host "SUCCESS: kiro-prime v$Version installed!" -ForegroundColor Green
Write-Host ""
Write-Host "What was installed:" -ForegroundColor Cyan
Write-Host "  - Core behavior rules -> ~/.kiro/steering/behavior.md" -ForegroundColor White
Write-Host "  - Global gitignore -> ~/.gitignore_global" -ForegroundColor White
if ($WithHooks) {
    Write-Host "  - Safety hooks -> ~/.kiro/hooks/guard-destructive.json" -ForegroundColor White
}
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open any project in Kiro" -ForegroundColor White
Write-Host "  2. Ask for a non-trivial task" -ForegroundColor White
Write-Host "  3. Verify you see a plan block and waiting for GO" -ForegroundColor White
Write-Host ""
Write-Host "Optional: Run init.ps1 inside a project for project-specific templates." -ForegroundColor Gray
Write-Host ""
