" TODO: figure out why this file isn't getting sourced correctly
" LSP setup
lua <<EOF
require'nvim_lsp'.pyls_ms.setup{on_attach=require'completion'.on_attach}
EOF
" LSP specific binds
nnoremap <silent> gd            <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]>         <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K             <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD            <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> 1gD           <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr            <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0            <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW            <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>fo    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gS            <cmd>lua vim.lsp.buf.rename()<CR>
" Format on save
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
