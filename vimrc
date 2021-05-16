scriptencoding utf-8
set encoding=utf-8

if has('syntax')
    syntax on
endif
if has('autocmd')
    filetype plugin indent on
endif

set backspace=indent,eol,start
set virtualedit=block

set number relativenumber
set showcmd ruler nolist
set cursorline
set showmatch matchpairs+=<:>
set hlsearch incsearch
set tabstop=4 softtabstop=4 shiftwidth=4
set smarttab expandtab
set autoindent smartindent
set hidden autowrite autoread lazyredraw
set formatoptions+=j
set fileformat=unix

noremap  Y y$
noremap  <C-c> <Esc>
noremap! <C-c> <Esc>
nnoremap J <C-e>
nnoremap K <C-y>
nnoremap <C-l> zl
nnoremap <C-h> zh
nnoremap ZW :w<CR>
nnoremap <C-d><Space> :buffer#<CR>
nnoremap <Space> za
nnoremap gV `[v`]
vnoremap < <gv
vnoremap > >gv
inoremap <C-l> <Esc>lDA