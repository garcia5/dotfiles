lua <<EOF
require'nvim_lsp'.tsserver.setup{on_attach=require'completion'.on_attach}
EOF

set shiftwidth=2
set ts=2
set softtabstop=2
