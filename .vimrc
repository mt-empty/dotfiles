set nocompatible
syntax on

" Line numbers
set number
set relativenumber

" Indentation — 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Appearance
set background=dark
set cursorline
set colorcolumn=80
set signcolumn=yes
set termguicolors

" Scroll context
set scrolloff=8

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Behaviour
set hidden
set clipboard=unnamedplus
set mouse=a
set splitright
set splitbelow
set wildmenu
set undofile

" Keymaps
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <Esc> :noh<CR>
nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
