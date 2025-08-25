" Make sure runtimepath points to repo
set runtimepath^=~/dotfiles/vim

" Plugins are already there — vim-plug just loads them
call plug#begin('~/dotfiles/vim/plugged')
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
call plug#end()
