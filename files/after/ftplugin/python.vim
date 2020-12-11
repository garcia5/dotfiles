" TODO: figure out why this file isn't getting sourced correctly
" LSP setup
lua <<EOF
require'lspconfig'.pyls.setup({
    on_attach=require'completion'.on_attach,
    plugins={
        pylint={
            enabled=true
        },
        pyflakes={
            enabled=flase
        },
        pydocstyle={
            enabled=false
        },
        rope_completion={
            enabled=false
        },
        yapf={
            enabled=true
        }
    }
})
EOF
