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
log_info() { printf "%s\n" "$1"; }
log_success() { printf "%s\n" "$1"; }
log_warning() { printf "%s\n" "$1"; }
log_error() { printf "%s\n" "$1" >&2; }

# Check if command exists - POSIX compliant
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get current timestamp - works on all Unix systems
get_timestamp() {
    date +%s 2>/dev/null || date +%Y%m%d%H%M%S
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
}

setup_binaries() {
    vim_bin_dir="$DOTFILES_DIR/vim/bin"
    home_bin_dir="$HOME/bin"

    # Check if source directory exists
    if [ ! -d "$vim_bin_dir" ]; then
        log_warning "vim/bin directory not found: $vim_bin_dir"
        return 0
    fi

    # Create bin directory if it doesn't exist
    if ! mkdir -p "$home_bin_dir" 2>/dev/null; then
        log_error "Failed to create bin directory: $home_bin_dir"
        return 1
    fi

    if [ ! -d "$home_bin_dir" ]; then
        log_info "Created bin directory: $home_bin_dir"
    fi

    # Find all executable files (no extension for Unix)
    executable_files=""
    if [ -d "$vim_bin_dir" ]; then
        # Find all regular files in bin directory
        for file in "$vim_bin_dir"/*; do
            # Skip if no files match the pattern
            [ ! -e "$file" ] && continue

            # Skip directories
            [ -d "$file" ] && continue

            # Get just the filename
            filename="$(basename "$file")"

            # Skip files with extensions (like .exe, .txt, etc.)
            case "$filename" in
                *.*) continue ;;
                *)
                    # Check if it's a regular file and potentially executable
                    if [ -f "$file" ]; then
                        if [ -z "$executable_files" ]; then
                            executable_files="$file"
                        else
                            executable_files="$executable_files $file"
                        fi
                    fi
                    ;;
            esac
        done
    fi

    if [ -z "$executable_files" ]; then
        log_info "No executable files found in: $vim_bin_dir"
        return 0
    fi

    success_count=0
    failure_count=0

    # Process each executable file
    for src_file in $executable_files; do
        filename="$(basename "$src_file")"
        dest="$home_bin_dir/$filename"

        # Make source file executable if it isn't already
        if [ ! -x "$src_file" ]; then
            if chmod +x "$src_file" 2>/dev/null; then
                log_info "Made $filename executable"
            else
                log_warning "Could not make $filename executable, trying anyway"
            fi
        fi

        # Remove existing file/symlink if it exists
        if [ -e "$dest" ] || [ -L "$dest" ]; then
            if ! rm -f "$dest" 2>/dev/null; then
                log_warning "Cannot remove existing $filename - may be in use"
                failure_count=$((failure_count + 1))
                continue
            fi
        fi

        # Check write permissions in destination directory
        if ! touch "$dest.test" 2>/dev/null; then
            log_warning "No write permission for: $dest"
            failure_count=$((failure_count + 1))
            continue
        fi
        rm -f "$dest.test" 2>/dev/null

        # Try to create symlink first, fallback to copy
        link_success=false
        if ln -sf "$src_file" "$dest" 2>/dev/null; then
            if [ -L "$dest" ] && [ -e "$dest" ]; then
                log_success "$filename symlinked to: $dest"
                success_count=$((success_count + 1))
                link_success=true
            fi
        fi

        # If symlink failed, try copying
        if [ "$link_success" = false ]; then
            if cp "$src_file" "$dest" 2>/dev/null; then
                # Make the copied file executable
                chmod +x "$dest" 2>/dev/null || true

                # Verify the copy was successful
                if [ -f "$dest" ] && [ -x "$dest" ]; then
                    log_success "$filename copied to: $dest"
                    success_count=$((success_count + 1))
                else
                    log_warning "$filename copy may have failed"
                    failure_count=$((failure_count + 1))
                fi
            else
                log_warning "Failed to copy $filename"
                failure_count=$((failure_count + 1))
            fi
        fi
    done

    # Summary logging
    if [ "$success_count" -gt 0 ]; then
        log_info "Successfully processed $success_count executable(s) to bin directory"
    fi
    if [ "$failure_count" -gt 0 ]; then
        log_warning "$failure_count executable(s) failed to process"
    fi

    return 0
}

copy_directory_contents_flat() {
    source_path="$1"
    destination_path="$2"

    if [ ! -d "$source_path" ]; then
        return 0
    fi

    # Create destination directory if it doesn't exist
    mkdir -p "$destination_path"

    # Use find to copy contents while maintaining flat structure
    (
        cd "$source_path" || return 1
        find . -type f -exec sh -c '
            dest_dir="'"$destination_path"'"
            src_file="$1"
            # Remove leading ./
            clean_path="${src_file#./}"
            target="$dest_dir/$clean_path"
            target_dir="$(dirname "$target")"

            # Create target directory if needed
            mkdir -p "$target_dir"

            # Copy the file
            cp "$src_file" "$target"
        ' _ {} \;
    )
}

install_vim_config() {
    host_plugins="$HOST_VIM_DIR/plugged"

    # Create vim directory if it doesn't exist
    mkdir -p "$HOST_VIM_DIR"

    if [ ! -d "$HOST_VIM_DIR" ]; then
        log_info "Created vim directory: $HOST_VIM_DIR"
    fi

    # Backup existing plugins
    if [ -d "$host_plugins" ]; then
        backup="${host_plugins}.backup-$(get_timestamp)"
        if mv "$host_plugins" "$backup" 2>/dev/null; then
            log_info "Backed up plugins to: $backup"
        fi
    fi

    # Sync vim config directory with flat structure
    if [ -d "$DOTFILE_VIM_DIR_SOURCE" ]; then
        copy_directory_contents_flat "$DOTFILE_VIM_DIR_SOURCE" "$HOST_VIM_DIR"
    fi

    # Backup existing .vimrc
    if [ -f "$HOME_DIR/.vimrc" ]; then
        backup="$HOME_DIR/.vimrc.backup-$(get_timestamp)"
        if mv "$HOME_DIR/.vimrc" "$backup" 2>/dev/null; then
            log_info "Backed up .vimrc to: $backup"
        fi
    fi

    # Install new .vimrc
    if cp "$DOTFILE_VIMRC_SOURCE" "$HOME_DIR/.vimrc" 2>/dev/null; then
        log_success "Vim configuration installed"
    else
        log_error "Failed to install .vimrc"
        return 1
    fi

    return 0
}

main() {
    check_if_vim_exist_before_runs
    setup_binaries
    install_vim_config
}

# Handle interruption signals
trap 'exit 1' INT TERM

main "$@"
exit 0
