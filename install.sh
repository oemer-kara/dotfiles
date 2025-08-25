#!/bin/bash
set -e

# Symlink .vimrc
ln -sf ~/dotfiles/.vimrc ~/.vimrc

# Ensure autoload path exists and copy vendored plug.vim
mkdir -p ~/.vim/autoload
cp ~/dotfiles/vim/autoload/plug.vim ~/.vim/autoload/plug.vim
