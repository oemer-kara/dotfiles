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
set nohlsearch
set cursorline
set relativenumber

" Leader key
let mapleader = " "
let maplocalleader = ","

" Disable netrw (using NERDTree instead)
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Additional settings mirrored from Lua
set synmaxcol=200
set noshowmode
set mouse=a
set clipboard=unnamedplus
set scrolloff=10
set sidescrolloff=8
set gdefault
set nofoldenable
set foldlevel=99
set splitright
set splitbelow
set equalalways
set history=10000
set undolevels=10000

" Buffer navigation
nnoremap <silent> < :bprevious<CR>
nnoremap <silent> > :bnext<CR>

" Keybindings mirrored from Lua config
" Utility
nnoremap <silent> vv V
nnoremap <silent> <C-s> :w<CR>
vnoremap <silent> b <C-v>
inoremap <silent> <C-h> <C-w>

" Window navigation
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Window resizing
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Right> :vertical resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize +2<CR>
nnoremap <silent> <C-+> :vertical resize =<CR>

" Keep cursor centered when scrolling and searching
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv

" Better indenting in visual mode (keep selection)
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Splits
nnoremap <silent> <leader>sh :split<CR>
nnoremap <silent> <leader>sv :vsplit<CR>
nnoremap <silent> <leader>sc :close<CR>

" Buffers
nnoremap <silent> <C-q> :bd<CR>

" Yank/Delete entire buffer
nnoremap <silent> <leader>ya ggVGy
nnoremap <silent> <leader>da ggVGd

" Visual selection search/replace
function! VisualBlockSearchReplace() range
  let l:search_term = input('Search for: ')
  if empty(l:search_term)
    return
  endif
  let l:replace_term = input('Replace with: ')
  if empty(l:replace_term)
    return
  endif
  execute "'<','>'s/" . escape(l:search_term, '/\\') . "/" . escape(l:replace_term, '/\\') . "/g"
endfunction
vnoremap <silent> <leader>sr :<C-u>call VisualBlockSearchReplace()<CR>

" Airline (loaded via native pack)
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" NERDTree convenience mapping
nnoremap <silent> <C-e> :silent! NERDTreeToggle<CR>

" If NERDTree is the last window, close Vim
augroup NERDTreeAutoClose
  autocmd!
  autocmd BufEnter * if winnr('$') == 1 && exists('t:NERDTreeBufName') && bufname() ==# t:NERDTreeBufName | quit | endif
augroup END

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

augroup UserAutoCmds
  autocmd!
  " Restore last cursor position
  autocmd BufReadPost * if line('"') > 1 && line('"') <= line('$') | execute 'normal! g`"' | endif
  " Briefly highlight yanked text (best-effort; requires +lua or nvim)
  if has('lua') || has('nvim')
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
  endif
  " Equalize splits on Vim resize
  autocmd VimResized * wincmd =
  " Strip trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e
  " Only show cursorline in active window
  autocmd WinEnter,BufEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
  " Disable auto-comment on newline
  autocmd BufEnter * set formatoptions-=cro
  " Reload files changed outside
  autocmd FocusGained,BufEnter * checktime
augroup END

" -----------------------------
" Ctags: config and keybindings
" -----------------------------
if executable('ctags')
  " Search for tags in current dir, then upward
  set tags=./tags;,tags
  command! -nargs=* CtagsGenerate silent! !ctags -R --fields=+l .
endif

" Rename symbol under cursor in current buffer (approximate :LSP rename)
function! RenameSymbol()
  let l:word = expand('<cword>')
  let l:new = input('Rename "' . l:word . '" to: ')
  if empty(l:new) || l:new ==# l:word
    return
  endif
  execute '%s/\V\<' . escape(l:word, '/\\') . '\>/' . escape(l:new, '/\\') . '/g'
endfunction

" Find references: ripgrep if available, else fallback to vimgrep
function! FindReferences()
  let l:word = expand('<cword>')
  if empty(l:word)
    return
  endif
  if executable('rg')
    " --vimgrep for quickfix format
    execute 'silent grep! -R --vimgrep --no-heading -- ' . shellescape(l:word)
  else
    " Best-effort recursive search
    execute 'silent vimgrep /' . escape(l:word, '/\\') . '/gj **/*'
  endif
  copen
endfunction

" Preview signature/info: show tag in preview window if available
function! PreviewTag()
  execute 'ptag ' . expand('<cword>')
endfunction

" LSP-like normal-mode mappings using ctags/quickfix
nnoremap <silent> gd <C-]>
nnoremap <silent> gD :tselect <C-R>=expand('<cword>')<CR><CR>
nnoremap <silent> K K
nnoremap <silent> gi :tjump <C-R>=expand('<cword>')<CR><CR>
" Keep existing <C-k> window navigation; provide alternative preview on <leader>k
nnoremap <silent> <leader>k :call PreviewTag()<CR>
nnoremap <silent> <leader>rn :call RenameSymbol()<CR>
nnoremap <silent> gr :call FindReferences()<CR>
nnoremap <silent> <leader>ct :CtagsGenerate<CR>