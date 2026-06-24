#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Project-level initialization script for kiro-prime.

.DESCRIPTION
    Adds optional project-specific kiro-prime files to the current directory:
    - .kiro/steering/project.md (project context)
    - progress.md (milestone tracker)
    - .gitignore (project gitignore starter)

.PARAMETER Force
    Overwrite existing files without prompting.

.PARAMETER WithHooks
    Install project-level hooks (reserved for future use).

.EXAMPLE
    .\init.ps1
    Initialize current project with templates.

.EXAMPLE
    .\init.ps1 -Force
    Overwrite existing files.
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$WithHooks
)

$ErrorActionPreference = 'Stop'

# Paths
$RepoRoot = Split-Path $PSScriptRoot -Parent
$RepoRoot = Join-Path $RepoRoot 'kiro-prime'
$ProjectRoot = Get-Location
$KiroDir = Join-Path $ProjectRoot '.kiro'
$KiroSteeringDir = Join-Path $KiroDir 'steering'

Write-Host "kiro-prime project initializer" -ForegroundColor Cyan
Write-Host ""
Write-Host "Target directory: $ProjectRoot" -ForegroundColor Gray
Write-Host ""

# Ensure .kiro/steering directory exists
if (-not (Test-Path $KiroSteeringDir)) {
    Write-Host "Creating .kiro/steering directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $KiroSteeringDir -Force | Out-Null
}

# Files to create
$FilesToCreate = @(
    @{
        Src = Join-Path $RepoRoot 'templates\project.md'
        Dst = Join-Path $KiroSteeringDir 'project.md'
        Name = 'Project context'
    },
    @{
        Src = Join-Path $RepoRoot 'templates\progress.md'
        Dst = Join-Path $ProjectRoot 'progress.md'
        Name = 'Progress tracker'
    },
    @{
        Src = Join-Path $RepoRoot 'templates\gitignore'
        Dst = Join-Path $ProjectRoot '.gitignore'
        Name = 'Project .gitignore'
    }
)

$Created = 0
$Skipped = 0

foreach ($file in $FilesToCreate) {
    if ((Test-Path $file.Dst) -and -not $Force) {
        Write-Host "  ⊘ $($file.Name) (already exists, use -Force)" -ForegroundColor Yellow
        $Skipped++
    } else {
        if (-not (Test-Path $file.Src)) {
            Write-Host "  ✗ $($file.Name) (template not found: $($file.Src))" -ForegroundColor Red
            continue
        }
        
        Copy-Item $file.Src $file.Dst -Force
        Write-Host "  ✓ $($file.Name) → $($file.Dst)" -ForegroundColor Green
        $Created++
    }
}

Write-Host ""
if ($Created -gt 0) {
    Write-Host "✅ Initialized $Created file(s) in $ProjectRoot" -ForegroundColor Green
    Write-Host ""
    Write-Host "What to do next:" -ForegroundColor Cyan
    Write-Host "  1. Edit .kiro/steering/project.md with your project's stack and conventions" -ForegroundColor White
    Write-Host "  2. Use progress.md to track milestones and decisions" -ForegroundColor White
    Write-Host "  3. Customize .gitignore for your project's needs" -ForegroundColor White
} else {
    Write-Host "No files created." -ForegroundColor Gray
}

if ($Skipped -gt 0) {
    Write-Host ""
    Write-Host "Skipped $Skipped existing file(s). Use -Force to overwrite." -ForegroundColor Yellow
}

Write-Host ""
