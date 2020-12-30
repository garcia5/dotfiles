set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Formatoptions, since the builtin lua.vim overwrites them
set formatoptions-=t       " Don't auto wrap text
set formatoptions+=c       " But do auto wrap comments
set formatoptions+=r       " Continue comments with <Enter>
set formatoptions-=o       " Do not continue comments with 'o' or 'O'
set formatoptions+=q       " Allow gq to format comments
set formatoptions+=j       " Remove comment leader when joining comment lines
set formatoptions-=2       " ... that's just weird
