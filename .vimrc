" Cross-platform Vim configuration that works offline with vendored plugins
" Plugins are installed as native packages under pack/vendor/start by install scripts

set nocompatible
set encoding=utf-8
syntax on
filetype plugin indent on

" Sensible defaults
set number
set hidden
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set ignorecase
set smartcase
set incsearch
set hlsearch
set termguicolors

" Airline (loaded via native pack)
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" NERDTree convenience mapping if plugin is present
if exists(':NERDTreeToggle')
  nnoremap <silent> <F2> :NERDTreeToggle<CR>
endif

" If running inside Neovim, keep the config compatible
if has('nvim')
  set shellcmdflag=-lc
endif

" -----------------------------
" Load plugins directly from repo
" -----------------------------
" Get the directory where this .vimrc file is located (the repo root)
let s:repo_root = expand('<sfile>:p:h')

" Add the vim directory to runtimepath
execute 'set runtimepath^=' . s:repo_root . '/vim'
execute 'set runtimepath+=' . s:repo_root . '/vim/after'

" Load all plugins from vim/plugged/ directory
let s:plugged_dir = s:repo_root . '/vim/plugged'
if isdirectory(s:plugged_dir)
  for s:plugin_dir in split(glob(s:plugged_dir . '/*', 1), '\n')
    if isdirectory(s:plugin_dir)
      execute 'set runtimepath+=' . s:plugin_dir
      " Also add after directories if they exist
      let s:after_dir = s:plugin_dir . '/after'
      if isdirectory(s:after_dir)
        execute 'set runtimepath+=' . s:after_dir
      endif
    endif
  endfor
endif

" Generate help tags for loaded plugins
silent! helptags ALL

" -----------------------------
" Additional Vim settings
" -----------------------------
set relativenumber
