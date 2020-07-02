" PLUG
call plug#begin('~/.vim/plugged')

" toggle comments on selected lines
Plug 'scrooloose/nerdcommenter'
" commands to surround words
Plug 'tpope/vim-surround'
" pretty status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" prettier
Plug 'prettier/vim-prettier'
" pretty screenshots
Plug 'segeljakt/vim-silicon'
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" better fzf integration
Plug 'junegunn/fzf.vim'
" LSP
if has('nvim-0.5')
  Plug 'neovim/nvim-lsp'
endif
" Git status in gutter
Plug 'airblade/vim-gitgutter'

" " Colorschemes
" anderson color scheme
Plug 'gilgigilgil/anderson.vim'
" srecry color scheme
Plug 'srcery-colors/srcery-vim'
" monokai pro color scheme
Plug 'phanviet/vim-monokai-pro'
" corvine
Plug 'arzg/vim-corvine'
" pretty colors
Plug 'chriskempson/base16-vim'

" All of your Plugins must be added before the following line
call plug#end()            " required


" THE BASICS
set nocompatible
" enable the mouse
set mouse="a"
set number
" highlight current line
set cursorline
" disable word wrap
set nowrap
" remap <Leader> key
let mapleader=" "
"make backspace work like it should
set backspace=indent,eol,start
" use bash as the terminal
set shell=/bin/bash
" move swap files
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" keep it centered
set scrolloff=999
" preview substitutions
if has("nvim")
  set inccommand=split
endif


" ~NERDTREE~ NETRW
" disable header
let g:netrw_banner = 0
" look like nerdtree
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" skinnier
let g:netrw_winsize = 20
" automatically hide dotfiles/folders
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide=ghregex
augroup ProjectDrawer
  autocmd!
  "autocmd VimEnter * :Vexplore
augroup END
let g:NetrwIsOpen=0
" let it toggle
function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr("$")
    while (i >= 1)
      if (getbufvar(i, "&filetype") == "netrw")
        silent exe "bwipeout " . i
      endif
      let i-=1
    endwhile
    let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Lexplore
  endif
endfunction


" FOLDING
set foldmethod=indent
set foldlevelstart=99


" ON SAVE
" remove trailing whitespace
"autocmd BufWritePre * :%s/\s\+$//e
nnoremap <silent> <Leader>tt :%s/\s\+$//e<CR>


" COLORS
" let colors display correctly
set t_co=256
set termguicolors
" set vim base16 color scheme based on termianl color scheme
"if filereadable(expand("~/.vimrc_background"))
"let base16colorspace=256
"source ~/.vimrc_background
"endif
colorscheme monokai_pro
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
" enable searching with fzf
set rtp+=/usr/local/opt/fzf
" look everywhere
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


" INDENTING
set autoindent
set smarttab
" <Tab> = 2 spaces
set shiftwidth=4
set ts=4
set softtabstop=4
set expandtab


" STATUS LINE
" always show status line
set laststatus=2
" always show file name and path
set statusline+="%f"


" MAPPINGS
nnoremap ; :
nnoremap : ;
inoremap jj <Esc>
nnoremap <silent> <Leader>no :nohl<CR>
" toggle Netrw
noremap <silent> <Leader>nt :call ToggleNetrw()<CR>:wincmd l<CR>
" move around better
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
" search files
nnoremap <silent> <Leader>ff :FZF<CR>
"search open buffers
nnoremap <silent> <Leader>fb :Buffers<CR>
" search lines in open buffers
nnoremap <silent> <Leader>fl :Lines<CR>
" search all lines in project
nnoremap <silent> <Leader>gg :Rg<CR>
command! MakeTags !ctags -R --exclude=*.pyc
" toggle focus
nnoremap <silent> <Leader>z :call ToggleFocus()<CR>

let g:expanded='false'
function! ToggleFocus()
  if( g:expanded ==? 'false' )
    wincmd |
    wincmd _
    let g:expanded = 'true'
  else
    wincmd =
    let g:expanded = 'false'
  endif
endfunction
