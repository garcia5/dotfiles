# Initial setup
0. Get `pyls_ms` setup
 - Install dotnet if necessary
 - `:LspInstall pyls_ms`
 - Make sure to install to nvim virtual environment if one is set up

# init.vim
0. Move to ~/.config/nvim/init.vim
1. Change plugged path
`call plug#begin(stdpath('data') . '/plugged')`
2. Add LSP and related plugins
```vimscript
" LSP and things
if has('nvim-0.5')
    Plug 'neovim/nvim-lsp'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
endif
```
3. Let nvim know we have LSP (outside of plug#begin)
```vimscript
if has('nvim-0.5')
    let g:builtin_lsp=v:true
endif
```
4. Other useful setup
```vimscript
set completeopt=menuone,noinsert,noselect
" preview :s commands
set inccommand=split
let g:python_host_prog='/usr/local/bin/python'
let g:python3_host_prog="$HOME/nvim-env/bin/python"
augroup Python
    autocmd BufReadPre,FileReadPre *.py set ft=python
augroup END
set noswapfile
```
# python.vim
0. Create python specific config
`mkdir -p $HOME/.config/nvim/after/ftplugin`
1. Setup python LSP with some options
```vimscript
" TODO: figure out why this file isn't getting sourced correctly
filetype plugin indent on
" LSP setup
lua <<EOF
require'nvim_lsp'.pyls_ms.setup{on_attach=require'completion'.on_attach}
EOF
" LSP specific binds
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" Format on save
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
```
