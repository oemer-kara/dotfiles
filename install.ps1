# Minimal Vim dotfiles installer (Windows PowerShell)

#Requires -Version 5.0

# Set strict mode for better error handling
Set-StrictMode -Version Latest

# Stop script on any error
$ErrorActionPreference = 'Stop'

$null = $true
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$DotfilesDir = $ScriptDir

$VimrcSource = Join-Path $DotfilesDir ".vimrc"
$VimDirSource = Join-Path $DotfilesDir "vim"
$HomeDir = $env:USERPROFILE
$VimConfigDir = Join-Path $HomeDir "vimfiles"

$null = $true

 
function Write-LogInfo { param([string]$Message) Write-Host "$Message" }
function Write-LogSuccess { param([string]$Message) Write-Host "$Message" }
function Write-LogWarning { param([string]$Message) Write-Host "$Message" }
function Write-LogError { param([string]$Message) Write-Host "$Message" }

function Test-CommandExists {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function New-DirectoryIfMissing {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        Write-LogInfo "Creating directory: $Path"
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
        Write-LogSuccess "Directory created: $Path"
    }
    else {
        Write-LogInfo "Directory already exists: $Path"
    }
}

function Copy-WithBackup {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$Directory
    )
    
    $backupSuffix = ".dotfiles-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    
    if (Test-Path $Destination) {
        Write-LogWarning "Destination exists: $Destination"
        $backupPath = "$Destination$backupSuffix"
        Write-LogInfo "Creating backup: $backupPath"
        
        if ($Directory) {
            Move-Item -Path $Destination -Destination $backupPath -Force
        }
        else {
            Copy-Item -Path $Destination -Destination $backupPath -Force
            Remove-Item -Path $Destination -Force
        }
        Write-LogSuccess "Backup created: $backupPath"
    }
    
    Write-LogInfo "Copying: $Source -> $Destination"
    
    if ($Directory) {
        Copy-Item -Path $Source -Destination $Destination -Recurse -Force
    }
    else {
        Copy-Item -Path $Source -Destination $Destination -Force
    }
    
    Write-LogSuccess "Copy completed: $Destination"
}

function Start-PreflightChecks {
    if (-not (Test-Path $VimrcSource)) { Write-LogError ".vimrc not found: $VimrcSource"; exit 1 }
    if (-not (Test-Path $VimDirSource)) { Write-LogError "vim directory not found: $VimDirSource"; exit 1 }
}

function Install-VimConfig {
    New-DirectoryIfMissing $VimConfigDir

    $existingPlugged = Join-Path $VimConfigDir "plugged"
    if (Test-Path $existingPlugged) {
        $backupPath = "$existingPlugged.dotfiles-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Move-Item -Path $existingPlugged -Destination $backupPath -Force
        Write-LogInfo "Backed up existing plugged to: $backupPath"
    }

    $items = Get-ChildItem -Path $VimDirSource -Force
    foreach ($item in $items) {
        $destPath = Join-Path $VimConfigDir $item.Name
        if (Test-Path $item.FullName -PathType Container) {
            Copy-Item -Path $item.FullName -Destination $destPath -Recurse -Force
        } else {
            Copy-Item -Path $item.FullName -Destination $destPath -Force
        }
    }

    $vimrcDest = Join-Path $HomeDir ".vimrc"
    if (Test-Path $vimrcDest) {
        $vimrcBackup = "$vimrcDest.dotfiles-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Move-Item -Path $vimrcDest -Destination $vimrcBackup -Force
        Write-LogInfo ".vimrc backed up to: $vimrcBackup"
    }
    Copy-Item -Path $VimrcSource -Destination $vimrcDest -Force
    Write-LogSuccess "Vim configuration installed"
}

$null = $true

$null = $true

function Test-PluginInstallation {
    try { $null = & vim --version 2>&1 } catch { }
}

$null = $true

function Complete-Installation { }

function Show-InstallationSummary { Write-LogSuccess "Dotfiles installed." }

function Start-Installation {
    try {
        Start-PreflightChecks
        Install-VimConfig
        Test-PluginInstallation
        Complete-Installation
        Show-InstallationSummary
    }
    catch {
        Write-LogError "Installation failed: $($_.Exception.Message)"
        exit 1
    }
}

$null = $true

# Start the installation
Start-Installation

# Exit successfully
exit 0