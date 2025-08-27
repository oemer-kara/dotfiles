#!/bin/sh

# Get script directory in a POSIX-compliant way
get_script_dir() {
    if [ -n "${BASH_SOURCE:-}" ]; then
        # Bash-specific method
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    else
        # POSIX-compliant fallback
        SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    fi
}

get_script_dir
DOTFILES_DIR="$SCRIPT_DIR"

# Define important paths
DOTFILE_VIMRC_SOURCE="$DOTFILES_DIR/.vimrc"
DOTFILE_VIM_DIR_SOURCE="$DOTFILES_DIR/vim"
HOME_DIR="$HOME"
HOST_VIM_DIR="$HOME_DIR/.vim"
WINDOWS_COMPAT="false"

# Logging functions
log_info() { printf "\033[34m[INFO]\033[0m %s\n" "$1"; }
log_success() { printf "\033[32m[SUCCESS]\033[0m %s\n" "$1"; }
log_warning() { printf "\033[33m[WARNING]\033[0m %s\n" "$1"; }
log_error() { printf "\033[31m[ERROR]\033[0m %s\n" "$1" >&2; }

# Check if command exists - POSIX compliant
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get current timestamp - works on all Unix systems
get_timestamp() {
    date +%Y%m%d_%H%M%S 2>/dev/null || date +%s
}

# Detect OS type in a portable way
detect_os() {
    if [ -n "${OSTYPE:-}" ]; then
        case "$OSTYPE" in
            msys*|cygwin*) return 0 ;;
            *) return 1 ;;
        esac
    fi

    # Fallback detection methods
    case "$(uname -s)" in
        CYGWIN*|MINGW*|MSYS*) return 0 ;;
        *) return 1 ;;
    esac
}

check_if_vim_exist_before_runs() {
    if [ ! -f "$DOTFILE_VIMRC_SOURCE" ]; then
        log_error ".vimrc not found: $DOTFILE_VIMRC_SOURCE"
        exit 1
    fi

    if [ ! -d "$DOTFILE_VIM_DIR_SOURCE" ]; then
        log_error "vim directory not found: $DOTFILE_VIM_DIR_SOURCE"
        exit 1
    fi

    if ! command_exists vim; then
        log_error "vim not found in PATH"
        exit 1
    fi

    # Set vim directory based on OS
    if detect_os; then
        HOST_VIM_DIR="$HOME_DIR/vimfiles"
        WINDOWS_COMPAT="true"
    else
        HOST_VIM_DIR="$HOME_DIR/.vim"
        WINDOWS_COMPAT="false"
    fi

    log_info "Target vim directory: $HOST_VIM_DIR"
}

setup_binaries() {
    vim_bin_dir="$DOTFILES_DIR/vim/bin"
    home_bin_dir="$HOME/bin"

    # Check if source directory exists
    if [ ! -d "$vim_bin_dir" ]; then
        log_warning "vim/bin directory not found: $vim_bin_dir"
        return 0
    fi

    log_info "Setting up binaries from: $vim_bin_dir"

    # Create bin directory if it doesn't exist
    if ! mkdir -p "$home_bin_dir" 2>/dev/null; then
        log_error "Failed to create bin directory: $home_bin_dir"
        return 1
    fi

    success_count=0
    failure_count=0

    # Process all files in bin directory
    for src_file in "$vim_bin_dir"/*; do
        # Skip if no files match the pattern
        [ ! -e "$src_file" ] && continue
        
        # Skip directories
        [ -d "$src_file" ] && continue

        filename="$(basename "$src_file")"
        dest="$home_bin_dir/$filename"

        log_info "Processing binary: $filename"

        # Remove existing file/symlink if it exists
        if [ -e "$dest" ] || [ -L "$dest" ]; then
            if ! rm -f "$dest" 2>/dev/null; then
                log_warning "Cannot remove existing $filename - may be in use"
                failure_count=$((failure_count + 1))
                continue
            fi
        fi

        # Copy the file
        if cp "$src_file" "$dest" 2>/dev/null; then
            # Make the copied file executable
            if chmod +x "$dest" 2>/dev/null; then
                # Verify the copy was successful and is executable
                if [ -f "$dest" ] && [ -x "$dest" ]; then
                    log_success "Binary installed: $dest"
                    success_count=$((success_count + 1))
                else
                    log_warning "Binary copy verification failed: $filename"
                    failure_count=$((failure_count + 1))
                fi
            else
                log_warning "Failed to make $filename executable"
                failure_count=$((failure_count + 1))
            fi
        else
            log_warning "Failed to copy $filename"
            failure_count=$((failure_count + 1))
        fi
    done

    # Summary logging
    if [ "$success_count" -gt 0 ]; then
        log_success "Successfully installed $success_count binary(s) to $home_bin_dir"
        log_info "Make sure $home_bin_dir is in your PATH"
        
        # Check if ~/bin is in PATH
        case ":$PATH:" in
            *":$home_bin_dir:"*) 
                log_success "$home_bin_dir is already in PATH" 
                ;;
            *) 
                log_warning "$home_bin_dir is NOT in PATH"
                log_info "Add this to your ~/.bashrc or ~/.profile:"
                log_info "export PATH=\"\$HOME/bin:\$PATH\""
                ;;
        esac
    fi
    if [ "$failure_count" -gt 0 ]; then
        log_warning "$failure_count binary(s) failed to install"
    fi

    return 0
}

# Improved directory copying that preserves structure
copy_directory_recursive() {
    source_path="$1"
    destination_path="$2"

    if [ ! -d "$source_path" ]; then
        log_warning "Source directory not found: $source_path"
        return 1
    fi

    log_info "Copying $source_path to $destination_path"

    # Create destination directory if it doesn't exist
    if ! mkdir -p "$destination_path"; then
        log_error "Failed to create destination directory: $destination_path"
        return 1
    fi

    # Use cp -r for recursive copy, or find + cp for more control
    if command_exists rsync; then
        # Use rsync if available (preserves permissions and is more reliable)
        if rsync -av --exclude='.git*' "$source_path/" "$destination_path/"; then
            log_success "Directory copied using rsync"
            return 0
        fi
    fi

    # Fallback to cp -r
    if cp -r "$source_path"/* "$destination_path/" 2>/dev/null; then
        log_success "Directory copied using cp"
        return 0
    fi

    # Final fallback using find
    (
        cd "$source_path" || return 1
        find . -type f | while read -r file; do
            target_dir="$destination_path/$(dirname "$file")"
            mkdir -p "$target_dir"
            cp "$file" "$target_dir/"
        done
    )
    
    return 0
}

install_vim_config() {
    log_info "Installing Vim configuration..."
    
    # Create vim directory if it doesn't exist
    if ! mkdir -p "$HOST_VIM_DIR"; then
        log_error "Failed to create vim directory: $HOST_VIM_DIR"
        return 1
    fi

    # Backup existing .vimrc
    if [ -f "$HOME_DIR/.vimrc" ]; then
        backup="$HOME_DIR/.vimrc.backup-$(get_timestamp)"
        if mv "$HOME_DIR/.vimrc" "$backup" 2>/dev/null; then
            log_info "Backed up existing .vimrc to: $backup"
        fi
    fi

    # Install new .vimrc
    if cp "$DOTFILE_VIMRC_SOURCE" "$HOME_DIR/.vimrc" 2>/dev/null; then
        log_success "Installed .vimrc"
    else
        log_error "Failed to install .vimrc"
        return 1
    fi

    # Install vim directory contents
    for subdir in autoload plugin; do
        src_dir="$DOTFILE_VIM_DIR_SOURCE/$subdir"
        dest_dir="$HOST_VIM_DIR/$subdir"
        
        if [ -d "$src_dir" ]; then
            log_info "Installing $subdir..."
            
            # Backup existing directory
            if [ -d "$dest_dir" ]; then
                backup="${dest_dir}.backup-$(get_timestamp)"
                if mv "$dest_dir" "$backup" 2>/dev/null; then
                    log_info "Backed up existing $subdir to: $backup"
                fi
            fi
            
            # Copy the directory
            if copy_directory_recursive "$src_dir" "$dest_dir"; then
                log_success "Installed $subdir"
            else
                log_error "Failed to install $subdir"
                return 1
            fi
        else
            log_warning "$subdir directory not found in source"
        fi
    done

    # Special handling for fzf if it exists
    fzf_src="$DOTFILE_VIM_DIR_SOURCE/plugin/fzf"
    if [ -d "$fzf_src" ]; then
        log_info "Setting up fzf integration..."
        
        # Create pack directory for native package loading (Vim 8+)
        pack_dir="$HOST_VIM_DIR/pack/plugins/start"
        if mkdir -p "$pack_dir"; then
            # Copy fzf and fzf.vim as separate packages
            for fzf_plugin in fzf fzf.vim; do
                fzf_plugin_src="$DOTFILE_VIM_DIR_SOURCE/plugin/$fzf_plugin"
                if [ -d "$fzf_plugin_src" ]; then
                    fzf_plugin_dest="$pack_dir/$fzf_plugin"
                    if copy_directory_recursive "$fzf_plugin_src" "$fzf_plugin_dest"; then
                        log_success "Installed $fzf_plugin as native package"
                    fi
                fi
            done
        fi
    fi

    return 0
}

verify_installation() {
    log_info "Verifying installation..."
    
    # Check if .vimrc exists and is readable
    if [ -r "$HOME_DIR/.vimrc" ]; then
        log_success ".vimrc is installed and readable"
    else
        log_error ".vimrc is missing or not readable"
        return 1
    fi
    
    # Check if essential binaries are accessible
    for binary in fzf rg; do
        if command_exists "$binary"; then
            log_success "$binary is available in PATH"
        else
            log_warning "$binary is not found in PATH"
        fi
    done
    
    # Check vim directories
    for dir in autoload plugin; do
        if [ -d "$HOST_VIM_DIR/$dir" ]; then
            file_count=$(find "$HOST_VIM_DIR/$dir" -type f | wc -l)
            log_success "$dir directory exists with $file_count files"
        else
            log_warning "$dir directory is missing"
        fi
    done
    
    return 0
}

main() {
    log_info "Starting Vim dotfiles installation..."
    
    check_if_vim_exist_before_runs
    
    if ! setup_binaries; then
        log_error "Binary setup failed"
        exit 1
    fi
    
    if ! install_vim_config; then
        log_error "Vim configuration installation failed"
        exit 1
    fi
    
    verify_installation
    
    log_success "Installation completed!"
    log_info "You may need to:"
    log_info "1. Add ~/bin to your PATH if not already done"
    log_info "2. Restart your terminal or source your shell configuration"
    log_info "3. Run :PlugInstall in Vim if using vim-plug"
}

# Handle interruption signals
trap 'log_error "Installation interrupted"; exit 1' INT TERM

main "$@"
exit 0