#!/bin/bash
#chmod +x install.sh
set -e

# Absolute path to the repo
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ensure autoload exists
mkdir -p ~/.vim/autoload

# Copy vendored plug.vim
cp "$DOTFILES_DIR/vim/autoload/plug.vim" ~/.vim/autoload/plug.vim

# Symlink .vimrc
ln -sf "$DOTFILES_DIR/.vimrc" ~/.vimrc

echo "Vim setup complete. Plugins are already included in the repo."
