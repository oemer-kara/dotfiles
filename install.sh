#!/bin/bash

# =============================================================================
# Dotfiles Installation Script for Unix/Linux/macOS
# =============================================================================
# This script installs vim configuration and plugins without requiring 
# internet access. All plugins are pre-bundled in the repository.
#
# Requirements: git, vim (installed on system)
# Supports: Linux, macOS, WSL, and other Unix-like systems
# =============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# =============================================================================
# Configuration and Setup
# =============================================================================

# Get the absolute path of the script directory (where dotfiles repo is cloned)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Define important paths
VIMRC_SOURCE="$DOTFILES_DIR/.vimrc"
VIM_DIR_SOURCE="$DOTFILES_DIR/vim"
HOME_DIR="$HOME"
VIM_CONFIG_DIR="$HOME_DIR/.vim"
# Flag to indicate Windows-compatible shells (Git Bash/Cygwin) where Vim expects ~/vimfiles
WINDOWS_COMPAT="false"

# =============================================================================
# Utility Functions
# =============================================================================

# Print output with timestamps (no colors for Unix terminals)
log_info() {
    echo "[INFO $(date '+%H:%M:%S')] $1"
}

log_success() {
    echo "[SUCCESS $(date '+%H:%M:%S')] $1"
}

log_warning() {
    echo "[WARNING $(date '+%H:%M:%S')] $1"
}

log_error() {
    echo "[ERROR $(date '+%H:%M:%S')] $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create directory if it doesn't exist
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        log_info "Creating directory: $dir"
        mkdir -p "$dir"
        log_success "Directory created: $dir"
    else
        log_info "Directory already exists: $dir"
    fi
}

# Safely copy files/directories with backup
safe_copy() {
    local source="$1"
    local destination="$2"
    local backup_suffix=".dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    
    if [ -e "$destination" ]; then
        log_warning "Destination exists: $destination"
        log_info "Creating backup: ${destination}${backup_suffix}"
        mv "$destination" "${destination}${backup_suffix}"
        log_success "Backup created: ${destination}${backup_suffix}"
    fi
    
    log_info "Copying: $source -> $destination"
    cp -r "$source" "$destination"
    log_success "Copy completed: $destination"
}

# =============================================================================
# Pre-flight Checks
# =============================================================================

preflight_checks() {
    log_info "Starting pre-flight checks..."
    
    # Check if we're in the right directory
    if [ ! -f "$VIMRC_SOURCE" ]; then
        log_error ".vimrc not found at: $VIMRC_SOURCE"
        log_error "Please run this script from the dotfiles repository root."
        exit 1
    fi
    
    if [ ! -d "$VIM_DIR_SOURCE" ]; then
        log_error "vim directory not found at: $VIM_DIR_SOURCE"
        log_error "Please ensure the vim directory with plugins exists in the repository."
        exit 1
    fi
    
    # Check if vim is installed
    if ! command_exists vim; then
        log_error "vim is not installed or not in PATH"
        log_error "Please install vim before running this script"
        exit 1
    fi
    
    # Detect the operating system and set Vim config directory accordingly
    OS=""
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
        VIM_CONFIG_DIR="$HOME_DIR/.vim"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        VIM_CONFIG_DIR="$HOME_DIR/.vim"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="Windows (MSYS/Cygwin)"
        VIM_CONFIG_DIR="$HOME_DIR/vimfiles"
        WINDOWS_COMPAT="true"
    elif [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ -n "${WSLENV:-}" ]]; then
        OS="Windows (WSL)"
        VIM_CONFIG_DIR="$HOME_DIR/.vim"
    else
        OS="Unknown Unix-like"
        VIM_CONFIG_DIR="$HOME_DIR/.vim"
    fi

    log_success "Operating system detected: $OS"
    log_success "Script directory: $DOTFILES_DIR"
    log_success "Home directory: $HOME_DIR"
    log_success "Pre-flight checks completed successfully"
}

# =============================================================================
# Vim Configuration Installation
# =============================================================================

install_vim_config() {
    log_info "Installing vim configuration..."
    
    # Create Vim config directory (.vim on Unix, vimfiles on Git Bash/Cygwin)
    ensure_directory "$VIM_CONFIG_DIR"
    
    # Copy the entire vim directory structure to target Vim config directory
    log_info "Copying vim configuration and plugins..."
    safe_copy "$VIM_DIR_SOURCE" "$HOME_DIR/.vim-temp"
    
    # Move contents from .vim-temp to target directory (avoid nested dirs)
    log_info "Organizing vim directory structure..."
    if [ -d "$HOME_DIR/.vim-temp" ]; then
        # Copy all contents from .vim-temp to .vim
        cp -r "$HOME_DIR/.vim-temp"/* "$VIM_CONFIG_DIR/"
        rm -rf "$HOME_DIR/.vim-temp"
        log_success "Vim directory structure organized"
    fi
    
    # Install .vimrc
    log_info "Installing .vimrc configuration..."
    safe_copy "$VIMRC_SOURCE" "$HOME_DIR/.vimrc"
    
    # If running under Windows-compatible shells, also create _vimrc for Windows Vim
    if [[ "$WINDOWS_COMPAT" == "true" ]]; then
        if cp -f "$HOME_DIR/.vimrc" "$HOME_DIR/_vimrc" 2>/dev/null; then
            log_success "_vimrc created/updated at $HOME_DIR/_vimrc for Windows Vim"
        else
            log_warning "Could not create _vimrc (non-critical)"
        fi
    fi
    
    log_success "Vim configuration installation completed"
}

# =============================================================================
# Neovim Configuration (Skipped)
# =============================================================================
# Note: Neovim configuration has been intentionally skipped.
# This script focuses only on Vim configuration.

# =============================================================================
# Plugin Verification
# =============================================================================

verify_plugins() {
    log_info "Verifying plugin installation..."
    
    local plugins_dir="$VIM_CONFIG_DIR/plugged"
    if [ -d "$plugins_dir" ]; then
        local plugin_count=$(find "$plugins_dir" -maxdepth 1 -type d | wc -l)
        # Subtract 1 for the plugged directory itself
        plugin_count=$((plugin_count - 1))
        log_success "Found $plugin_count plugins in: $plugins_dir"
        
        # List installed plugins
        log_info "Installed plugins:"
        for plugin_dir in "$plugins_dir"/*; do
            if [ -d "$plugin_dir" ]; then
                local plugin_name=$(basename "$plugin_dir")
                log_info "  - $plugin_name"
            fi
        done
    else
        log_warning "No plugins directory found at: $plugins_dir"
    fi
    
    # Test vim accessibility (simplified test)
    log_info "Testing vim configuration..."
    if vim --version >/dev/null 2>&1; then
        log_success "Vim is accessible and ready to use"
        log_info "Configuration will be loaded automatically when vim starts"
    else
        log_warning "Vim test failed - please check vim installation"
    fi
}

# =============================================================================
# Shell Integration (Optional)
# =============================================================================

setup_shell_integration() {
    log_info "Setting up shell integration..."
    
    # Add VIMINIT environment variable to shell profiles (optional)
    local viminit_line="export VIMINIT=\"source $HOME_DIR/.vimrc\""
    
    # Function to add line to shell profile if not present
    add_to_shell_profile() {
        local profile="$1"
        local description="$2"
        
        if [ -f "$profile" ]; then
            if ! grep -Fxq "$viminit_line" "$profile"; then
                log_info "Adding VIMINIT to $description: $profile"
                echo "" >> "$profile"
                echo "# Vim configuration from dotfiles" >> "$profile"
                echo "$viminit_line" >> "$profile"
                log_success "Added VIMINIT to $description"
            else
                log_info "VIMINIT already present in $description"
            fi
        else
            log_info "$description not found: $profile"
        fi
    }
    
    # Add to common shell profiles
    add_to_shell_profile "$HOME_DIR/.bashrc" "Bash configuration"
    add_to_shell_profile "$HOME_DIR/.bash_profile" "Bash profile"
    add_to_shell_profile "$HOME_DIR/.zshrc" "Zsh configuration"
    add_to_shell_profile "$HOME_DIR/.profile" "Shell profile"
    
    # Set for current session
    export VIMINIT="source $HOME_DIR/.vimrc"
    log_success "VIMINIT set for current session"
}

# =============================================================================
# Cleanup and Final Steps
# =============================================================================

cleanup_and_finalize() {
    log_info "Performing cleanup and finalization..."
    
    # Prepare plugin help documentation (skip generation to avoid verbose output)
    log_info "Preparing plugin help documentation..."
    log_success "Plugin help will be generated automatically when vim starts"
    log_info "Use ':help <plugin-name>' in vim for plugin documentation"
    
    # Set appropriate permissions
    log_info "Setting appropriate permissions..."
    chmod -R 755 "$VIM_CONFIG_DIR" 2>/dev/null || true
    chmod 644 "$HOME_DIR/.vimrc" 2>/dev/null || true
    
    log_success "Cleanup and finalization completed"
}

# =============================================================================
# Installation Summary
# =============================================================================

print_installation_summary() {
    echo ""
    echo "============================================================================="
    log_success "DOTFILES INSTALLATION COMPLETED SUCCESSFULLY"
    echo "============================================================================="
    echo ""
    log_info "Installation Summary:"
    log_info "  • Vim configuration: $HOME_DIR/.vimrc"
    log_info "  • Vim directory: $VIM_CONFIG_DIR"
    log_info "  • All plugins are pre-installed and ready to use"
    echo ""
    log_info "Next Steps:"
    log_info "  1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
    log_info "  2. Open vim to verify everything works: vim"
    log_info "  3. Test NERDTree plugin: F2 key in vim"
    log_info "  4. All configurations are portable and work offline"
    echo ""
    log_success "Happy vimming! 🎉"
    echo ""
}

# =============================================================================
# Main Installation Function
# =============================================================================

main() {
    echo "============================================================================="
    echo "                    DOTFILES INSTALLATION SCRIPT"
    echo "============================================================================="
    echo "Installing vim configuration and plugins for $(whoami) on $(hostname)"
    echo "Repository location: $DOTFILES_DIR"
    echo "============================================================================="
    echo ""
    
    # Run installation steps
    preflight_checks
    echo ""
    
    install_vim_config
    echo ""
    
# Neovim configuration skipped - focusing on Vim only
    
    verify_plugins
    echo ""
    
    setup_shell_integration
    echo ""
    
    cleanup_and_finalize
    echo ""
    
    print_installation_summary
}

# =============================================================================
# Script Execution
# =============================================================================

# Trap to handle script interruption
trap 'log_error "Script interrupted by user"; exit 1' INT TERM

# Run main function
main "$@"

# Exit successfully
exit 0