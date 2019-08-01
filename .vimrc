 " VUNDLE
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" new comment

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" toggle comments on selected lines
Plugin 'scrooloose/nerdcommenter'
" commands to surround words
Plugin 'tpope/vim-surround'
" pretty colors
Plugin 'chriskempson/base16-vim'
" pretty status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" all the git
Plugin 'tpope/vim-fugitive'
" linting
Plugin 'w0rp/ale'
" prettier
Plugin 'prettier/vim-prettier'
" anderson color scheme
Plugin 'gilgigilgil/anderson.vim'
" srecry color scheme
Plugin 'srcery-colors/srcery-vim'
" pretty screenshots
Plugin 'segeljakt/vim-silicon'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" THE BASICS
" set runtime env to real vim
if has('nvim')
	let $VIMRUNTIME='/usr/local/share/vim/vim81'
endif
" best numbering
if exists('+relativenumber')
  set number relativenumber  "Display how far away each line is from the current one by default
    " Switch to absolute line numbers whenever Vim loses focus
    autocmd FocusLost * :set number
    autocmd FocusGained * :set relativenumber
    " Use absolute line numbers when in insert mode and relative numbers when in normal mode
    autocmd InsertEnter * :set norelativenumber | set number
    autocmd InsertLeave * :set relativenumber
else
    set number          " Show absolute line numbers
endif
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

" enable searching with fzf
set rtp+=/usr/local/opt/fzf

nnoremap <silent> <Leader>ff :FZF<CR>


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
noremap <silent> <Leader>nt :call ToggleNetrw()<CR>:wincmd l<CR>
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
" auto complete matching symbols
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap { {}<Left>
" auto expand grouping symbols
inoremap [<CR> []<Esc>i<CR><CR><Esc>ki<Tab>
inoremap (<CR> ()<Esc>i<CR><CR><Esc>ki<Tab>
inoremap {<CR> {}<Esc>i<CR><CR><Esc>ki<Tab>
