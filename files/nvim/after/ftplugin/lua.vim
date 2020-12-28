set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Formatoptions, since the builtin lua.vim overwrites them
set fo-=t       " Don't auto wrap text
set fo+=c       " But do auto wrap comments
set fo+=r       " Continue comments with <Enter>
set fo-=o       " Do not continue comments with 'o' or 'O'
set fo+=q       " Allow gq to format comments
set fo+=j       " Remove comment leader when joining comment lines
set fo-=2       " ... that's just weird
