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

setup_fzf_binary() {
    src="$DOTFILES_DIR/vim/bin/fzf"
    dest="$HOME/bin/fzf"

    if [ ! -f "$src" ]; then
        log_warning "fzf binary not found: $src"
        return
    fi

    if [ ! -x "$src" ]; then
        chmod +x "$src" && log_success "fzf is now executable"
    fi

    # Create bin directory if it doesn't exist
    mkdir -p "$HOME/bin"

    # Remove existing symlink/file if it exists
    [ -e "$dest" ] && rm -f "$dest"

    # Create symlink (use cp on systems where ln -s might not work)
    if ln -sf "$src" "$dest" 2>/dev/null; then
        log_success "fzf symlinked to: $dest"
    else
        # Fallback to copying if symlink fails
        cp "$src" "$dest" && log_success "fzf copied to: $dest"
    fi
}

install_vim_config() {
    host_plugins="$HOST_VIM_DIR/plugged"

    # Create vim directory if it doesn't exist
    mkdir -p "$HOST_VIM_DIR"

    # Backup existing plugins
    if [ -d "$host_plugins" ]; then
        backup="${host_plugins}.backup-$(get_timestamp)"
        mv "$host_plugins" "$backup" && log_info "Backed up plugins to: $backup"
    fi

    # Sync vim config directory
    # Use more portable copying method
    if [ -d "$DOTFILE_VIM_DIR_SOURCE" ]; then
        # Copy contents recursively
        (cd "$DOTFILE_VIM_DIR_SOURCE" && find . -type f -exec sh -c '
            target="'"$HOST_VIM_DIR"'/$1"
            mkdir -p "$(dirname "$target")"
            cp "$1" "$target"
        ' _ {} \;)
    fi

    # Backup existing .vimrc
    if [ -f "$HOME_DIR/.vimrc" ]; then
        backup="$HOME_DIR/.vimrc.backup-$(get_timestamp)"
        mv "$HOME_DIR/.vimrc" "$backup" && log_info "Backed up .vimrc to: $backup"
    fi

    # Install new .vimrc
    cp "$DOTFILE_VIMRC_SOURCE" "$HOME_DIR/.vimrc"
    log_success "Vim configuration installed"
}

main() {
    check_if_vim_exist_before_runs
    setup_fzf_binary
    install_vim_config
}

# Handle interruption signals
trap 'exit 1' INT TERM

main "$@"
exit 0
