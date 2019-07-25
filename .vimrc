 " VUNDLE
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" new comment

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" nerdtree
Plugin 'scrooloose/nerdtree'
" show git modified in nerdtree
Plugin 'Xuyuanp/nerdtree-git-plugin'
" toggle comments on selected lines
Plugin 'scrooloose/nerdcommenter'
" commands to surround words
Plugin 'tpope/vim-surround'
" pretty colors
Plugin 'chriskempson/base16-vim'
" easily align text
Plugin 'godlygeek/tabular'
" pretty status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" all the git
Plugin 'tpope/vim-fugitive'
" linting
Plugin 'w0rp/ale'
" latex
Plugin 'vim-latex/vim-latex'
" prettier
Plugin 'prettier/vim-prettier'
" anderson color scheme
Plugin 'gilgigilgil/anderson.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" THE BASICS
" set runtime env to real vim
let $VIMRUNTIME='/usr/local/share/vim/vim81'
" best numbering
set number relativenumber
" highlight current line
set cursorline
" disable word wrap
set nowrap
" remap <Leader> key
let mapleader=" "
"make backspace work like it should
set backspace=indent,eol,start
" get move swap files
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp


" NERDTREE
" auto start nerdtree
autocmd vimenter * NERDTree
" don't auto enter nerdtree
autocmd vimenter * wincmd w
" automatically start nerdtree in working directory if one is given
autocmd StdinReadPre * let s:std_in=1
" set root dir to given directory if one is provided (rather than current
" directory)
autocmd vimenter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" exit vim if nerdtree is the last open buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" hide 'help' message
let g:NERDTreeMinimalUI = 1


" ON SAVE
" remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" COLORS
" let colors display correctly
set t_co=256
set termguicolors
" set vim base16 color scheme based on termianl color scheme
"if filereadable(expand("~/.vimrc_background"))
"  let base16colorspace=256
"  source ~/.vimrc_background
"endif
colorscheme anderson
" pretty highlighting
syntax on
filetype plugin indent on
set background=dark
" make fzf match color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" SEARCHING
set path+=**
" tab complete on :file
set wildmenu
" only match case if using capital letters
set ignorecase
set smartcase
" hightlight matched words while searching
set hlsearch
" do incremental searching
set incsearch
" enable searching with fzf
set rtp+=/usr/local/opt/fzf

" INDENTING
set autoindent
set smarttab
" <Tab> = 2 spaces
set shiftwidth=2
set ts=2
set softtabstop=2
set expandtab

"LINTING
" ale
let g:ale_linters = { 'javascript': ['eslint'], }

" STATUS LINE
" always show status line
set laststatus=2
" always show file name and path
set statusline+="%f"

" MAPPINGS
inoremap jj <Esc>
nnoremap <silent> <Leader>no :nohl<CR>
nnoremap <silent> <Leader>ff :FZF<CR>
nnoremap <silent> <Leader>nt :NERDTreeToggle<CR>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
command! MakeTags !ctags -R --exclude=*.pyc
" skip over closing grouping symbols/quotes
inoremap <expr> ] getline('.')[getpos('.')[2] - 1] == ']' ? '<Right>' : ']'
inoremap <expr> ) getline('.')[getpos('.')[2] - 1] == ')' ? '<Right>' : ')'
inoremap <expr> } getline('.')[getpos('.')[2] - 1] == '}' ? '<Right>' : '}'
inoremap <expr> > getline('.')[getpos('.')[2] - 1] == '>' ? '<Right>' : '>'
" auto complete matching symbols
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap < <><Left>
inoremap " ""<Left>
" auto expand grouping symbols
inoremap [<CR> []<Esc>i<CR><CR><Esc>ki<Tab>
inoremap (<CR> ()<Esc>i<CR><CR><Esc>ki<Tab>
inoremap {<CR> {}<Esc>i<CR><CR><Esc>ki<Tab>
