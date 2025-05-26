#Requires -Version 5.0
<#
.SYNOPSIS
All-in-one script to set up the BMAD Method for VS Code with Roo.

.DESCRIPTION
Clones or updates the repository, builds the web agent, copies the
bmad-agent folder to your Operator Shell project, and syncs changes
with GitHub.

.PARAMETER RepoUrl
HTTPS URL of the BMAD-METHOD repository.

.PARAMETER TargetDir
Local directory where the repo will be cloned or updated.

.PARAMETER OperatorShellPath
Path to your Operator Shell project root. If supplied, the bmad-agent
folder is copied here.

.EXAMPLE
./setup-bmad.ps1 -RepoUrl https://github.com/example/BMAD-METHOD.git `
                 -TargetDir C:\BMAD-METHOD `
                 -OperatorShellPath C:\MyOperatorShell
#>

param(
    [string]$RepoUrl = 'https://github.com/YOUR_ORG/BMAD-METHOD.git',
    [string]$TargetDir = "$PSScriptRoot\BMAD-METHOD",
    [string]$OperatorShellPath
)

function Ensure-Command([string]$cmd) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Error "$cmd is not installed or not in PATH."
        exit 1
    }
}

Ensure-Command git
Ensure-Command node

if (-not (Test-Path $TargetDir)) {
    git clone $RepoUrl $TargetDir
} else {
    Push-Location $TargetDir
    git pull
    Pop-Location
}

Push-Location $TargetDir

node build-web-agent.js

git add -A
if (-not (git diff --cached --quiet)) {
    git commit -m "chore: build web agent"
}

$branch = git rev-parse --abbrev-ref HEAD
git pull --rebase origin $branch
git push origin $branch

Pop-Location

if ($OperatorShellPath) {
    $src = Join-Path $TargetDir 'bmad-agent'
    $dest = Join-Path $OperatorShellPath 'bmad-agent'
    Copy-Item $src -Destination $dest -Recurse -Force
    Write-Host "Copied bmad-agent to $dest"
}

Write-Host "Setup complete."
