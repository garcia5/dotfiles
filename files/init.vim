" PLUG {{{
call plug#begin(stdpath('data') . '/plugged')
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" better fzf integration
Plug 'junegunn/fzf.vim'
" LSP
if has('nvim-0.5')
  Plug 'neovim/nvim-lsp'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter'
endif
" Git status in gutter
Plug 'airblade/vim-gitgutter'
" Auto complete pairs
Plug 'jiangmiao/auto-pairs'
" Surround
Plug 'tpope/vim-surround'
" ... and make them repeatable
Plug 'tpope/vim-repeat'

" Colorschemes
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
" better syntax highlighting
Plug 'sheerun/vim-polyglot'

" format on save
Plug 'lukas-reineke/format.nvim'

" icons
"Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}


" BASICS {{{
if has('nvim-0.5')
    let g:builtin_lsp=v:true
endif
set rtp+=/usr/local/bin/fzf
set number
set cursorline
set nowrap
" no bells!
set noerrorbells
set vb t_vb=
set completeopt=menuone,noinsert,noselect
" preview :s commands
set inccommand=split
let g:python3_host_prog='/usr/local/bin/python3'
set noswapfile
set backspace=indent,eol,start
set lcs=tab:»·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·
set list
set scrolloff=15
set hidden " Change buffers without having to save
set encoding=utf8
set formatoptions-=o " O and o, don't continue comments
set formatoptions+=r " But do continue when pressing enter.
set foldmethod=marker " fold on curly braces
set shell=/usr/local/bin/zsh " use zsh as shell
lua require'lsp_config'
" }}}


" ON SAVE {{{
lua <<EOF
require 'format'.setup {
    python = {
        {cmd={"black"}}
    }
}
EOF
augroup OnSave
    autocmd!
    autocmd BufWritePre * FormatWrite
augroup END
" }}}


" COLORS {{{
" let colors display correctly
set t_co=256
set termguicolors
let base16colorspace=256
" pretty highlighting
syntax on
filetype plugin indent on
set background=dark
" base16 settings
if (v:true) " to toggle base16 colors
    if filereadable(expand("~/.vimrc_background"))
      source ~/.vimrc_background
    endif
else
    colorscheme srcery
    let g:airline_theme='ayu_dark'
endif
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
" }}}


" FONTS {{{
let g:webdevicons_enable = 1
let g:airline_powerline_fonts = 1
let g:webdevicons_enable_airline_statusline = 1
" }}}


" GIT(gutter) {{{
set updatetime=100
let g:gitgutter_git_executable='/usr/bin/git'
" }}}


" TREE-SITTER {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indent = {
    enable = true,
  },
}
EOF
" }}}


" NETRW {{{
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
" }}}


" SEARCH {{{
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
" }}}


" INDENTING {{{
set autoindent
set smarttab
" <Tab> = 4 spaces
set shiftwidth=4
set ts=4
set softtabstop=4
set expandtab
" }}}


" STATUS LINE {{{
" always show status line
set laststatus=2
" always show file name and path
set statusline+="%f"
" }}}


" TERMINAL {{{
augroup term
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber
    autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif
augroup end
" }}}


" MAPPINGS {{{
inoremap jj <Esc>
let mapleader=" "
nnoremap <silent> <Leader>no :nohl<CR>

" toggle paste
nnoremap <silent> <Leader>pp :set paste!<CR>

" trim trailing whitespace
nnoremap <silent> <Leader>tt :%s/\s\+$//<CR>

" Movemint
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" search all files, respecting .gitignore if one exists
nnoremap <silent> <Leader>ff <cmd>:Files<CR>
"search open buffers
nnoremap <silent> <Leader>fb <cmd>:Buffers<CR>
"search lines in open buffers
nnoremap <silent> <Leader>fl <cmd>:Lines<CR>
" search all lines in project
nnoremap <silent> <Leader>gg <cmd>:Rg<CR>

nnoremap <silent> <Leader>nt :call ToggleNetrw()<CR>
" toggle list chars
nnoremap <silent> <Leader>sl :set list!<CR>
"
" Terminal mappings
" remap escape
tnoremap <Esc><Esc> <C-\><C-n>
" movemint from terminal 'insert' mode
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
" }}}
