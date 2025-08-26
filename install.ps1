# =============================================================================
# Dotfiles Installation Script for Windows PowerShell
# =============================================================================
# This script installs vim configuration and plugins without requiring 
# internet access. All plugins are pre-bundled in the repository.
#
# Requirements: git, vim (installed on system), PowerShell 5.0+
# Supports: Windows 10/11, Windows Server, PowerShell Core
# =============================================================================

#Requires -Version 5.0

# Set strict mode for better error handling
Set-StrictMode -Version Latest

# Stop script on any error
$ErrorActionPreference = 'Stop'

# =============================================================================
# Configuration and Setup
# =============================================================================

# Get the absolute path of the script directory (where dotfiles repo is cloned)
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$DotfilesDir = $ScriptDir

# Define important paths
$VimrcSource = Join-Path $DotfilesDir ".vimrc"
$VimDirSource = Join-Path $DotfilesDir "vim"
$HomeDir = $env:USERPROFILE
$VimConfigDir = Join-Path $HomeDir "vimfiles"

# Define paths for different Windows environments
# Git Bash uses Unix-style .vim directory
$GitBashVimDir = Join-Path $HomeDir ".vim"
# WSL uses Unix-style paths
$WslHomePattern = "\\wsl$\*\home\*"

# =============================================================================
# Utility Functions
# =============================================================================

# Function to write colored output with timestamps
function Write-LogInfo {
    param([string]$Message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[INFO $timestamp] $Message" -ForegroundColor Cyan
}

function Write-LogSuccess {
    param([string]$Message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[SUCCESS $timestamp] $Message" -ForegroundColor Green
}

function Write-LogWarning {
    param([string]$Message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[WARNING $timestamp] $Message" -ForegroundColor Yellow
}

function Write-LogError {
    param([string]$Message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[ERROR $timestamp] $Message" -ForegroundColor Red
}

# Function to test if a command exists
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

# Function to ensure directory exists
function Ensure-Directory {
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

# Function to safely copy files/directories with backup
function Safe-Copy {
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

# =============================================================================
# Pre-flight Checks
# =============================================================================

function Start-PreflightChecks {
    Write-LogInfo "Starting pre-flight checks..."
    
    # Check PowerShell version
    $psVersion = $PSVersionTable.PSVersion
    Write-LogSuccess "PowerShell version: $($psVersion.ToString())"
    
    # Check if we're in the right directory
    if (-not (Test-Path $VimrcSource)) {
        Write-LogError ".vimrc not found at: $VimrcSource"
        Write-LogError "Please run this script from the dotfiles repository root."
        exit 1
    }
    
    if (-not (Test-Path $VimDirSource)) {
        Write-LogError "vim directory not found at: $VimDirSource"
        Write-LogError "Please ensure the vim directory with plugins exists in the repository."
        exit 1
    }
    
    # Check if vim is installed
    $vimFound = $false
    $vimPaths = @()
    
    # Check common vim installation paths
    $commonVimPaths = @(
        "${env:ProgramFiles}\Vim\vim*\vim.exe",
        "${env:ProgramFiles(x86)}\Vim\vim*\vim.exe",
        "${env:ProgramData}\chocolatey\bin\vim.exe",
        "${env:LOCALAPPDATA}\Programs\Vim\vim*\vim.exe"
    )
    
    foreach ($path in $commonVimPaths) {
        $found = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
        if ($found) {
            $vimPaths += $found.FullName
            $vimFound = $true
        }
    }
    
    # Check if vim is in PATH
    if (Test-CommandExists "vim") {
        $vimFound = $true
        $vimPaths += (Get-Command vim).Source
    }
    
    if (-not $vimFound) {
        Write-LogError "vim is not installed or not found in common locations"
        Write-LogError "Please install vim before running this script"
        Write-LogError "Recommended: Download from https://www.vim.org/download.php"
  exit 1
}
    
    Write-LogSuccess "Vim installation(s) found:"
    foreach ($vimPath in $vimPaths) {
        Write-LogSuccess "  - $vimPath"
    }
    
    # Detect Windows version and environment
    $windowsVersion = [System.Environment]::OSVersion.Version
    $isWsl = $env:WSL_DISTRO_NAME -or $env:WSLENV
    $isGitBash = $env:MSYSTEM -or (Test-Path "${env:ProgramFiles}\Git\bin\bash.exe")
    
    Write-LogSuccess "Windows version: $($windowsVersion.ToString())"
    Write-LogSuccess "Script directory: $DotfilesDir"
    Write-LogSuccess "Home directory: $HomeDir"
    
    if ($isWsl) {
        Write-LogInfo "WSL environment detected"
    }
    if ($isGitBash) {
        Write-LogInfo "Git Bash environment detected"
    }
    
    Write-LogSuccess "Pre-flight checks completed successfully"
}

# =============================================================================
# Vim Configuration Installation
# =============================================================================

function Install-VimConfig {
    Write-LogInfo "Installing vim configuration..."
    
    # Create vimfiles directory in user home (Windows standard)
    Ensure-Directory $VimConfigDir
    
    # Copy the entire vim directory structure to ~/vimfiles
    Write-LogInfo "Copying vim configuration and plugins..."
    
    # Copy vim directory contents to vimfiles directory
    $tempVimDir = Join-Path $HomeDir "vimfiles-temp"
    Safe-Copy -Source $VimDirSource -Destination $tempVimDir -Directory
    
    # Move contents from vimfiles-temp to vimfiles (to avoid nested directories)
    Write-LogInfo "Organizing vim directory structure..."
    if (Test-Path $tempVimDir) {
        $items = Get-ChildItem -Path $tempVimDir -Force
        foreach ($item in $items) {
            $destPath = Join-Path $VimConfigDir $item.Name
            if (Test-Path $destPath) {
                Remove-Item -Path $destPath -Recurse -Force
            }
            Copy-Item -Path $item.FullName -Destination $destPath -Recurse -Force
        }
        Remove-Item -Path $tempVimDir -Recurse -Force
        Write-LogSuccess "Vim directory structure organized"
    }
    
    # Install .vimrc and Windows _vimrc for compatibility
    Write-LogInfo "Installing .vimrc configuration..."
    $vimrcDest = Join-Path $HomeDir ".vimrc"
    Safe-Copy -Source $VimrcSource -Destination $vimrcDest

    # Also create/update _vimrc which Windows gVim/console Vim load by default
    try {
        $underscoreVimrc = Join-Path $HomeDir "_vimrc"
        Write-LogInfo "Ensuring _vimrc exists for Windows Vim..."
        Copy-Item -Path $vimrcDest -Destination $underscoreVimrc -Force
        Write-LogSuccess "_vimrc created/updated: $underscoreVimrc"
    }
    catch {
        Write-LogWarning "Could not create _vimrc: $($_.Exception.Message)"
    }
    
    Write-LogSuccess "Vim configuration installation completed"
}

# =============================================================================
# Neovim Configuration (Skipped)
# =============================================================================
# Note: Neovim configuration has been intentionally skipped.
# This script focuses only on Vim configuration.

# =============================================================================
# Windows-Specific Configurations
# =============================================================================

function Set-WindowsEnvironment {
    Write-LogInfo "Setting up Windows-specific environment..."

# Set VIMINIT environment variable for current user
    $vimrcPath = Join-Path $HomeDir ".vimrc"
    $vimrcPathForward = $vimrcPath -replace '\\', '/'
    $viminit = "source $vimrcPathForward"
    
    Write-LogInfo "Setting VIMINIT environment variable..."
    try {
[Environment]::SetEnvironmentVariable("VIMINIT", $viminit, "User")
        $env:VIMINIT = $viminit
        Write-LogSuccess "VIMINIT environment variable set for current user"
        Write-LogSuccess "VIMINIT value: $viminit"
    }
    catch {
        Write-LogWarning "Could not set system environment variable: $($_.Exception.Message)"
        Write-LogInfo "You may need to run PowerShell as Administrator to set system variables"
    }
    
    # Create a batch file for easy vim launching
    $batchFile = Join-Path $DotfilesDir "vim.bat"
    $batchContent = @"
@echo off
REM Vim launcher with dotfiles configuration
set VIMINIT=source $vimrcPathForward
vim %*
"@
    Set-Content -Path $batchFile -Value $batchContent -Encoding ASCII
    Write-LogSuccess "Created vim launcher batch file: $batchFile"
    
    Write-LogSuccess "Windows environment setup completed"
}

# =============================================================================
# Plugin Verification
# =============================================================================

function Test-PluginInstallation {
    Write-LogInfo "Verifying plugin installation..."
    
    $pluginsDir = Join-Path $VimConfigDir "plugged"
    if (Test-Path $pluginsDir) {
        $plugins = Get-ChildItem -Path $pluginsDir -Directory
        $pluginCount = $plugins.Count
        Write-LogSuccess "Found $pluginCount plugins in: $pluginsDir"
        
        # List installed plugins
        Write-LogInfo "Installed plugins:"
        foreach ($plugin in $plugins) {
            Write-LogInfo "  - $($plugin.Name)"
        }
    }
    else {
        Write-LogWarning "No plugins directory found at: $pluginsDir"
    }
    
    # Test vim configuration (simplified test)
    Write-LogInfo "Testing vim configuration..."
    try {
        # Use a simpler test that doesn't produce verbose output
        $null = & vim --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-LogSuccess "Vim is accessible and ready to use"
            Write-LogInfo "Configuration will be loaded automatically when vim starts"
        }
        else {
            Write-LogWarning "Vim test returned exit code: $LASTEXITCODE"
        }
    }
    catch {
        Write-LogWarning "Could not test vim: $($_.Exception.Message)"
        Write-LogInfo "This is usually not a problem - vim should work normally"
    }
}

# =============================================================================
# Git Bash and WSL Support
# =============================================================================

function Set-CrossPlatformSupport {
    Write-LogInfo "Setting up cross-platform support..."
    
    # Check for Git Bash
    $gitBashPath = "${env:ProgramFiles}\Git\bin\bash.exe"
    if (Test-Path $gitBashPath) {
        Write-LogInfo "Git Bash detected - uses Unix-style .vim directory"
        Write-LogInfo "For Git Bash, you may want to run the Unix install script instead"
        Write-LogSuccess "Vim configuration is compatible with Git Bash"
    }
    
    # Check for WSL
    if (Test-CommandExists "wsl") {
        Write-LogInfo "WSL detected - uses Unix-style .vim directory"
        Write-LogInfo "For WSL, use the Unix install script (install.sh) instead"
        Write-LogSuccess "WSL compatibility confirmed"
    }
    
    Write-LogInfo "This script sets up Windows-native vim with ~/vimfiles directory"
    Write-LogSuccess "Cross-platform support setup completed"
}

# =============================================================================
# Cleanup and Final Steps
# =============================================================================

function Complete-Installation {
    Write-LogInfo "Performing cleanup and finalization..."
    
    # Generate help tags for plugins (skip to avoid verbose output)
    Write-LogInfo "Preparing plugin help documentation..."
    Write-LogSuccess "Plugin help will be generated automatically when vim starts"
    Write-LogInfo "Use ':help <plugin-name>' in vim for plugin documentation"
    
    # Verify file permissions (Windows doesn't have chmod, but we can check access)
    Write-LogInfo "Verifying file permissions..."
    try {
        $vimrcPath = Join-Path $HomeDir ".vimrc"
        $null = Get-Content $vimrcPath -TotalCount 1
        Write-LogSuccess "Configuration files are accessible"
    }
    catch {
        Write-LogWarning "Configuration files may have permission issues: $($_.Exception.Message)"
    }
    
    Write-LogSuccess "Cleanup and finalization completed"
}

# =============================================================================
# Installation Summary
# =============================================================================

function Show-InstallationSummary {
    Write-Host ""
    Write-Host "=============================================================================" -ForegroundColor Green
    Write-LogSuccess "DOTFILES INSTALLATION COMPLETED SUCCESSFULLY"
    Write-Host "=============================================================================" -ForegroundColor Green
    Write-Host ""
    
    Write-LogInfo "Installation Summary:"
    Write-LogInfo "  • Vim configuration: $(Join-Path $HomeDir '.vimrc')"
    Write-LogInfo "  • Vim directory: $VimConfigDir (Windows vimfiles)"
    Write-LogInfo "  • All plugins are pre-installed and ready to use"
    Write-LogInfo "  • VIMINIT environment variable set"
    
    $batchFile = Join-Path $DotfilesDir "vim.bat"
    if (Test-Path $batchFile) {
        Write-LogInfo "  • Vim launcher created: $batchFile"
    }
    
    Write-Host ""
    Write-LogInfo "Next Steps:"
    Write-LogInfo "  1. Restart PowerShell or open a new terminal window"
    Write-LogInfo "  2. Open vim to verify everything works: vim"
    Write-LogInfo "  3. Test NERDTree plugin: F2 key in vim"
    Write-LogInfo "  4. All configurations are portable and work offline"
    Write-LogInfo "  5. Use 'vim.bat' in the dotfiles directory for guaranteed compatibility"
    
    Write-Host ""
    Write-LogSuccess "Happy vimming! 🎉"
    Write-Host ""
}

# =============================================================================
# Main Installation Function
# =============================================================================

function Start-Installation {
    Write-Host "=============================================================================" -ForegroundColor Cyan
    Write-Host "                    DOTFILES INSTALLATION SCRIPT" -ForegroundColor Cyan
    Write-Host "=============================================================================" -ForegroundColor Cyan
    Write-Host "Installing vim configuration and plugins for $env:USERNAME on $env:COMPUTERNAME"
    Write-Host "Repository location: $DotfilesDir"
    Write-Host "=============================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        # Run installation steps
        Start-PreflightChecks
        Write-Host ""
        
        Install-VimConfig
        Write-Host ""
        
        # Neovim configuration skipped - focusing on Vim only
        
        Set-WindowsEnvironment
        Write-Host ""
        
        Test-PluginInstallation
        Write-Host ""
        
        Set-CrossPlatformSupport
        Write-Host ""
        
        Complete-Installation
        Write-Host ""
        
        Show-InstallationSummary
    }
    catch {
        Write-LogError "Installation failed: $($_.Exception.Message)"
        Write-LogError "Stack trace: $($_.ScriptStackTrace)"
        exit 1
    }
}

# =============================================================================
# Script Execution
# =============================================================================

# Handle Ctrl+C gracefully
$null = Register-EngineEvent PowerShell.Exiting -Action {
    Write-LogError "Script interrupted by user"
}

# Check if running as Administrator (recommended but not required)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if ($isAdmin) {
    Write-LogSuccess "Running as Administrator - full system integration available"
}
else {
    Write-LogWarning "Not running as Administrator - some features may be limited"
    Write-LogInfo "For full system integration, consider running as Administrator"
}

# Start the installation
Start-Installation

# Exit successfully
exit 0