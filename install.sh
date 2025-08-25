#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Set VIMINIT to use the repo's .vimrc directly
VIMRC_PATH="$DOTFILES_DIR/.vimrc"

if [ ! -f "$VIMRC_PATH" ]; then
  echo "Error: .vimrc not found at $VIMRC_PATH"
  exit 1
fi

# Add VIMINIT to shell profiles
add_to_profile() {
  local profile="$1"
  local line="export VIMINIT=\"source $VIMRC_PATH\""
  
  if [ -f "$profile" ]; then
    if ! grep -Fxq "$line" "$profile"; then
      echo "$line" >> "$profile"
      echo "Added VIMINIT to $profile"
    else
      echo "VIMINIT already set in $profile"
    fi
  fi
}

# Add to common shell profiles
add_to_profile "$HOME/.bashrc"
add_to_profile "$HOME/.zshrc"
add_to_profile "$HOME/.profile"

# Set for current session
export VIMINIT="source $VIMRC_PATH"

# Setup Neovim to use the same configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"
cat >"$NVIM_CONFIG_DIR/init.vim" <<EOF
source $VIMRC_PATH
EOF

echo "Vim setup complete. VIMINIT points to repo's .vimrc at: $VIMRC_PATH"
echo "Neovim configured to use the same .vimrc"
echo "Please restart your shell or run: source ~/.bashrc (or ~/.zshrc)"