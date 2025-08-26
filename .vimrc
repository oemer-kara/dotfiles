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
set relativenumber

" Buffer navigation
nnoremap <silent> < :bprevious<CR>
nnoremap <silent> > :bnext<CR>

" Airline (loaded via native pack) — minimal, low-noise setup
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tagbar#enabled = 0
let g:airline_section_a = '%{airline#mode()}'
let g:airline_section_b = ''
let g:airline_section_c = '%t'
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = '%l:%c %p%%'

" NERDTree convenience mapping if plugin is present
if exists(':NERDTreeToggle')
  nnoremap <silent> <C-e> :NERDTreeToggle<CR>
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

" Load plugins from multiple offline locations
" 1) Repo vendor dir:   <repo>/vim/plugged
" 2) Unix home dir:     ~/.vim/plugged
" 3) Windows home dir:  ~/vimfiles/plugged
let s:plug_roots = [
\  s:repo_root . '/vim/plugged',
\  expand('~/.vim/plugged'),
\  expand('~/vimfiles/plugged')
\]

for s:root in s:plug_roots
  if isdirectory(s:root)
    for s:plugin_dir in split(glob(s:root . '/*', 1), '\n')
      if isdirectory(s:plugin_dir)
        execute 'set runtimepath+=' . s:plugin_dir
        let s:after_dir = s:plugin_dir . '/after'
        if isdirectory(s:after_dir)
          execute 'set runtimepath+=' . s:after_dir
        endif
      endif
    endfor
  endif
endfor

" Generate help tags for loaded plugins
silent! helptags ALL
 -----------------------------