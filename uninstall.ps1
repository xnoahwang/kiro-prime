#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Uninstall script for kiro-prime.

.DESCRIPTION
    Removes all files installed by kiro-prime using the manifest.
    Safely cleans up global configuration without affecting projects.

.PARAMETER KeepBackup
    Keep a backup of removed files before deleting.

.EXAMPLE
    .\uninstall.ps1
    Remove kiro-prime installation.

.EXAMPLE
    .\uninstall.ps1 -KeepBackup
    Remove kiro-prime but keep backup of files.
#>

[CmdletBinding()]
param(
    [switch]$KeepBackup
)

$ErrorActionPreference = 'Stop'

$UserHome = $env:USERPROFILE
$ManifestPath = Join-Path $UserHome '.kiro-prime-manifest.json'

Write-Host "kiro-prime uninstaller" -ForegroundColor Cyan
Write-Host ""

# Check if manifest exists
if (-not (Test-Path $ManifestPath)) {
    Write-Host "⚠️  No kiro-prime installation found." -ForegroundColor Yellow
    Write-Host "Manifest not found at: $ManifestPath" -ForegroundColor Gray
    exit 1
}

# Load manifest
try {
    $Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
} catch {
    Write-Host "✗ Failed to read manifest: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Found kiro-prime v$($Manifest.version)" -ForegroundColor Gray
Write-Host "Installed: $($Manifest.installedAt)" -ForegroundColor Gray
Write-Host ""

# Optional backup
if ($KeepBackup) {
    $BackupDir = Join-Path $UserHome ".kiro-prime-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "Creating backup at: $BackupDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    
    foreach ($file in $Manifest.files) {
        $expandedPath = [System.Environment]::ExpandEnvironmentVariables($file)
        if (Test-Path $expandedPath) {
            $dest = Join-Path $BackupDir (Split-Path $expandedPath -Leaf)
            Copy-Item $expandedPath $dest -Force
            Write-Host "  ✓ Backed up: $(Split-Path $expandedPath -Leaf)" -ForegroundColor Gray
        }
    }
    Write-Host ""
}

# Remove files
Write-Host "Removing files..." -ForegroundColor Cyan
$Removed = 0
$NotFound = 0

foreach ($file in $Manifest.files) {
    $expandedPath = [System.Environment]::ExpandEnvironmentVariables($file)
    
    if (Test-Path $expandedPath) {
        Remove-Item $expandedPath -Force
        Write-Host "  ✓ Removed: $file" -ForegroundColor Green
        $Removed++
    } else {
        Write-Host "  ⊘ Not found: $file" -ForegroundColor Gray
        $NotFound++
    }
}

# Remove manifest
Remove-Item $ManifestPath -Force
Write-Host "  ✓ Removed: manifest" -ForegroundColor Green

Write-Host ""
Write-Host "✅ kiro-prime uninstalled successfully!" -ForegroundColor Green
Write-Host "  Removed: $Removed file(s)" -ForegroundColor Gray
if ($NotFound -gt 0) {
    Write-Host "  Already gone: $NotFound file(s)" -ForegroundColor Gray
}

if ($KeepBackup) {
    Write-Host ""
    Write-Host "Backup saved at: $BackupDir" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Note: Project-level files (.kiro/steering/project.md, progress.md)" -ForegroundColor Yellow
Write-Host "      were NOT removed. Delete them manually if needed." -ForegroundColor Yellow
Write-Host ""
