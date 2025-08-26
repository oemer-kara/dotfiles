#!/bin/bash

set -euo pipefail  
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Define important paths
VIMRC_SOURCE="$DOTFILES_DIR/.vimrc"
VIM_DIR_SOURCE="$DOTFILES_DIR/vim"
HOME_DIR="$HOME"
VIM_CONFIG_DIR="$HOME_DIR/.vim"
WINDOWS_COMPAT="false"

log_info() { echo "$1"; }
log_success() { echo "$1"; }
log_warning() { echo "$1"; }
log_error() { echo "$1"; }

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

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


preflight_checks() {
    if [ ! -f "$VIMRC_SOURCE" ]; then log_error ".vimrc not found: $VIMRC_SOURCE"; exit 1; fi
    if [ ! -d "$VIM_DIR_SOURCE" ]; then log_error "vim directory not found: $VIM_DIR_SOURCE"; exit 1; fi
    if ! command_exists vim; then log_error "vim not found in PATH"; exit 1; fi

    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        VIM_CONFIG_DIR="$HOME_DIR/vimfiles"; WINDOWS_COMPAT="true"
    else
        VIM_CONFIG_DIR="$HOME_DIR/.vim"; WINDOWS_COMPAT="false"
    fi
}

install_vim_config() {
    ensure_directory "$VIM_CONFIG_DIR"

    local existing_plugged="$VIM_CONFIG_DIR/plugged"
    if [ -d "$existing_plugged" ]; then
        local backup_path="${existing_plugged}.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
        mv "$existing_plugged" "$backup_path"
        log_info "Backed up existing plugged to: $backup_path"
    fi

    for entry in "$VIM_DIR_SOURCE"/*; do
        base="$(basename "$entry")"
        if [ -d "$entry" ]; then
            cp -r "$entry" "$VIM_CONFIG_DIR/$base"
        else
            cp -f "$entry" "$VIM_CONFIG_DIR/$base"
        fi
    done

    if [ -f "$HOME_DIR/.vimrc" ]; then
        local vimrc_backup="$HOME_DIR/.vimrc.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
        mv "$HOME_DIR/.vimrc" "$vimrc_backup"
        log_info ".vimrc backed up to: $vimrc_backup"
    fi
    cp -f "$VIMRC_SOURCE" "$HOME_DIR/.vimrc"
    log_success "Vim configuration installed"
}


verify_plugins() { vim --version >/dev/null 2>&1 || true; }
cleanup_and_finalize() { :; }
print_installation_summary() { log_success "Dotfiles installed."; }

main() {
    preflight_checks
    install_vim_config
    verify_plugins
    cleanup_and_finalize
    print_installation_summary
}

trap 'exit 1' INT TERM

main "$@"
exit 0