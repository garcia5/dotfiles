lua <<EOF
require'nvim_lsp'.vuels.setup{on_attach=require'completion'.on_attach}
EOF

set shiftwidth=2
set ts=2
set softtabstop=2
