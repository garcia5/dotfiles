call plug#begin(stdpath('data') . '/plugged')
" toggle comments on selected lines
Plug 'scrooloose/nerdcommenter'
" commands to surround words
Plug 'tpope/vim-surround'
" pretty status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" prettier
Plug 'prettier/vim-prettier'
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" better fzf integration
Plug 'junegunn/fzf.vim'
" LSP and things
if has('nvim-0.5')
    Plug 'neovim/nvim-lsp'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
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
call plug#end()


" BASICS
if has('nvim-0.5')
    let g:builtin_lsp=v:true
endif
set number
set cursorline
set mouse="a"
set backspace=indent,eol,start
set completeopt=menuone,noinsert,noselect
" preview :s commands
set inccommand=split
let g:python_host_prog='/usr/local/bin/python'
let g:python3_host_prog="$HOME/nvim-env/bin/python"
augroup Python
    autocmd BufReadPre,FileReadPre *.py set ft=python
augroup END
set noswapfile


" INDENTING
set autoindent
set smarttab
" <Tab> = 4 spaces
set shiftwidth=4
set ts=4
set softtabstop=4
set expandtab


" NETRW
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


" COLORS
" let colors display correctly
set t_co=256
set termguicolors
" set vim base16 color scheme based on termianl color scheme
"if filereadable(expand("~/.vimrc_background"))
"let base16colorspace=256
"source ~/.vimrc_background
"endif
colorscheme srcery
" pretty highlighting
syntax enable
filetype plugin on
set background=dark
" make fzf match color scheme
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
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
set rtp+=/usr/local/bin/fzf
" look everywhere
set path+=.,**
" tab complete on :file
set wildmenu
" only match case if using capital letters
set ignorecase
set smartcase
" hightlight matched words while searching
set hlsearch
" do incremental searching
set incsearch


" MAPPINGS
let mapleader = " "
inoremap jj <Esc>
nnoremap <leader>S :source %<CR>
nnoremap <leader>no :nohl<CR>

" move around better
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

" Terminal mappings
" " esc exits terminal
tnoremap <Esc> <C-\><C-n>
" " movemint
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l

noremap <silent> <Leader>nt :call ToggleNetrw()<CR>:wincmd l<CR>

" trim whitespace
nnoremap <silent> <Leader>tt :%s/\s\+$//e<CR>
" search files
nnoremap <silent> <Leader>ff :FZF<CR>
"search open buffers
nnoremap <silent> <Leader>fb :Buffers<CR>
" search lines in open buffers
nnoremap <silent> <Leader>fl :Lines<CR>
" search all lines in project
nnoremap <silent> <Leader>gg :Rg<CR>
nnoremap <silent> <Leader>z :call ToggleFocus()<CR>
" custom text objects
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" skip over closing grouping symbols
inoremap <expr> ] getline('.')[getpos('.')[2] - 1] == ']' ? '<Right>' : ']'
inoremap <expr> ) getline('.')[getpos('.')[2] - 1] == ')' ? '<Right>' : ')'
inoremap <expr> } getline('.')[getpos('.')[2] - 1] == '}' ? '<Right>' : '}'
" auto complete matching symbols (if necessary)
function! WhitespaceNext()
    return match(getline('.')[getpos('.')[2] - 1], '\S') !=? -1
endfunction
inoremap <expr> [ WhitespaceNext() == '1' ? '[' : '[]<Left>'
inoremap <expr> ( WhitespaceNext() == '1' ? '(' : '()<Left>'
inoremap <expr> { WhitespaceNext() == '1' ? '{' : '{}<Left>'
" auto expand grouping symbols
inoremap [<CR> []<Left><CR><CR><Up><Tab>
inoremap (<CR> ()<Left><CR><CR><Up><Tab>
inoremap {<CR> {}<Left><CR><CR><Up><Tab>

function! ToggleFocus()
    let g:expanded='false'
    if( g:expanded ==? 'false' )
        wincmd |
        wincmd _
        let g:expanded = 'true'
    else
        wincmd =
        let g:expanded = 'false'
    endif
endfunction
