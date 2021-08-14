setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

" Formatoptions, since the builtin lua.vim overwrites them
setlocal formatoptions-=t       " Don't auto wrap text
setlocal formatoptions+=c       " But do auto wrap comments
setlocal formatoptions+=r       " Continue comments with <Enter>
setlocal formatoptions-=o       " Do not continue comments with 'o' or 'O'
setlocal formatoptions+=q       " Allow gq to format comments
setlocal formatoptions+=j       " Remove comment leader when joining comment lines
setlocal formatoptions-=2       " ... that's just weird
