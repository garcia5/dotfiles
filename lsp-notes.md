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
set noswapfile
```
# LSP configuration
All LSP configuration is done *once* in `lua/lsp_config.lua`. Add `lua require'lsp_config'` to source file

Mappings are set up here that only apply if an LSP client is attached, and this makes sure that the client only attaches once.
