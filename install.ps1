#Requires -Version 3.0

# Minimal Vim dotfiles installer (Windows PowerShell) - Unix equivalent

# Set strict mode and error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Get script directory - equivalent to Unix version
$SCRIPT_DIR = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
$DOTFILES_DIR = $SCRIPT_DIR

# Define important paths - matching Unix variable names
$DOTFILE_VIMRC_SOURCE = Join-Path $DOTFILES_DIR ".vimrc"
$DOTFILE_VIM_DIR_SOURCE = Join-Path $DOTFILES_DIR "vim"
$HOME_DIR = $env:USERPROFILE
$HOST_VIM_DIR = Join-Path $HOME_DIR "vimfiles"
$WINDOWS_COMPAT = "true"

# Logging functions - exactly matching Unix output format
function log_info { param([string]$Message) Write-Host "$Message" }
function log_success { param([string]$Message) Write-Host "$Message" }
function log_warning { param([string]$Message) Write-Host "$Message" }
function log_error { param([string]$Message) Write-Host "$Message" }

# Check if command exists - equivalent to Unix command_exists
function command_exists {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Get timestamp - equivalent to Unix get_timestamp
function get_timestamp {
    try {
        return [int][double]::Parse((Get-Date -UFormat %s))
    }
    catch {
        return Get-Date -Format "yyyyMMddHHmmss"
    }
}

function check_if_vim_exist_before_runs {
    if (-not (Test-Path $DOTFILE_VIMRC_SOURCE)) {
        log_error ".vimrc not found: $DOTFILE_VIMRC_SOURCE"
        exit 1
    }

    if (-not (Test-Path $DOTFILE_VIM_DIR_SOURCE -PathType Container)) {
        log_error "vim directory not found: $DOTFILE_VIM_DIR_SOURCE"
        exit 1
    }

    if (-not (command_exists "vim")) {
        log_error "vim not found in PATH"
        exit 1
    }

    # Windows always uses vimfiles directory
    $global:HOST_VIM_DIR = Join-Path $HOME_DIR "vimfiles"
    $global:WINDOWS_COMPAT = "true"
}

function setup_binaries {
    $vimBinDir = Join-Path $DOTFILES_DIR "vim\bin"
    $homeBinDir = Join-Path $HOME_DIR "bin"

    # Check if source directory exists
    if (-not (Test-Path $vimBinDir -PathType Container)) {
        log_warning "vim\bin directory not found: $vimBinDir"
        return
    }

    # Create destination directory with error handling
    try {
        if (-not (Test-Path $homeBinDir)) {
            New-Item -ItemType Directory -Force -Path $homeBinDir | Out-Null
            log_info "Created bin directory: $homeBinDir"
        }
    }
    catch {
        log_error "Failed to create bin directory $homeBinDir`: $($_.Exception.Message)"
        return
    }

    # Get all files and filter for .exe explicitly with error handling
    try {
        $allFiles = Get-ChildItem -Path $vimBinDir -File -ErrorAction Stop
        $exeFiles = $allFiles | Where-Object { $_.Extension -eq '.exe' }
    }
    catch {
        log_error "Failed to read vim\bin directory $vimBinDir`: $($_.Exception.Message)"
        return
    }

    if ($exeFiles.Count -eq 0) {
        log_info "No .exe files found in: $vimBinDir"
        return
    }

    log_info "Found $($exeFiles.Count) .exe file(s) to copy"

    $successCount = 0
    $failureCount = 0

    foreach ($exeFile in $exeFiles) {
        $dest = Join-Path $homeBinDir $exeFile.Name

        try {
            # Check if source file is accessible
            if (-not (Test-Path $exeFile.FullName -PathType Leaf)) {
                log_warning "Source file no longer exists: $($exeFile.FullName)"
                $failureCount++
                continue
            }

            # Check if destination file is in use (Windows-specific issue)
            if (Test-Path $dest) {
                try {
                    Remove-Item -Path $dest -Force -ErrorAction Stop
                }
                catch {
                    log_warning "Cannot overwrite $($exeFile.Name) - file may be in use: $($_.Exception.Message)"
                    $failureCount++
                    continue
                }
            }

            # Verify we have write permissions to destination
            $tempFile = "$dest.temp"
            try {
                New-Item -ItemType File -Path $tempFile -Force | Out-Null
                Remove-Item -Path $tempFile -Force
            }
            catch {
                log_warning "No write permission for: $dest"
                $failureCount++
                continue
            }

            # Copy .exe file
            Copy-Item -Path $exeFile.FullName -Destination $dest -Force -ErrorAction Stop

            # Verify the copy was successful
            if (Test-Path $dest) {
                $sourceSize = (Get-Item $exeFile.FullName).Length
                $destSize = (Get-Item $dest).Length
                if ($sourceSize -eq $destSize) {
                    log_success "$($exeFile.Name) copied to: $dest"
                    $successCount++
                } else {
                    log_warning "$($exeFile.Name) copy may be incomplete (size mismatch)"
                    $failureCount++
                }
            } else {
                log_warning "$($exeFile.Name) copy failed - destination file not found"
                $failureCount++
            }
        }
        catch {
            log_warning "Failed to copy $($exeFile.Name): $($_.Exception.Message)"
            $failureCount++
        }
    }

    # Summary logging
    if ($successCount -gt 0) {
        log_info "Successfully copied $successCount executable(s) to bin directory"
    }
    if ($failureCount -gt 0) {
        log_warning "$failureCount executable(s) failed to copy"
    }
}

function copy_directory_contents_flat {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    if (-not (Test-Path $SourcePath -PathType Container)) {
        return
    }

    $items = Get-ChildItem -Path $SourcePath -Force
    foreach ($item in $items) {
        $destPath = Join-Path $DestinationPath $item.Name

        if ($item.PSIsContainer) {
            # For directories, create them in destination but don't nest
            if (-not (Test-Path $destPath)) {
                New-Item -ItemType Directory -Force -Path $destPath | Out-Null
            }
            # Recursively copy contents but maintain flat structure in destination
            copy_directory_contents_flat -SourcePath $item.FullName -DestinationPath $destPath
        } else {
            # Copy files directly
            Copy-Item -Path $item.FullName -Destination $destPath -Force
        }
    }
}

function install_vim_config {
    $host_plugins = Join-Path $HOST_VIM_DIR "plugged"

    # Create vim directory if it doesn't exist
    if (-not (Test-Path $HOST_VIM_DIR)) {
        New-Item -ItemType Directory -Force -Path $HOST_VIM_DIR | Out-Null
        log_info "Created vim directory: $HOST_VIM_DIR"
    }

    # Backup existing plugins
    if (Test-Path $host_plugins) {
        $backup = "$host_plugins.backup-$(get_timestamp)"
        Move-Item -Path $host_plugins -Destination $backup -Force
        log_info "Backed up plugins to: $backup"
    }

    # Sync vim config directory with flat structure
    if (Test-Path $DOTFILE_VIM_DIR_SOURCE -PathType Container) {
        copy_directory_contents_flat -SourcePath $DOTFILE_VIM_DIR_SOURCE -DestinationPath $HOST_VIM_DIR
    }

    # Backup existing .vimrc
    $vimrcDest = Join-Path $HOME_DIR ".vimrc"
    if (Test-Path $vimrcDest) {
        $backup = "$vimrcDest.backup-$(get_timestamp)"
        Move-Item -Path $vimrcDest -Destination $backup -Force
        log_info "Backed up .vimrc to: $backup"
    }

    # Install new .vimrc
    Copy-Item -Path $DOTFILE_VIMRC_SOURCE -Destination $vimrcDest -Force
    log_success "Vim configuration installed"
}

function main {
    check_if_vim_exist_before_runs
    setup_binaries
    install_vim_config
}

# Handle interruption signals - PowerShell equivalent of trap
$null = Register-EngineEvent PowerShell.Exiting -Action { exit 1 }

try {
    main
    exit 0
}
catch {
    log_error $_.Exception.Message
    exit 1
}
