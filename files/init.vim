" Setup
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
let g:python_host_prog='/usr/local/bin/python'
let g:python3_host_prog="$HOME/nvim-env/bin/python"
let g:builtin_lsp=v:true

" Preview substitutions
set inccommand=split

" Terminal mappings
" " use zsh
set shell=$HOMEBREW_PREFIX/zsh
" " esc exits terminal
tnoremap <Esc> <C-\><C-n>
" " movemint
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l

source $DF_HOME/files/.vimrc
