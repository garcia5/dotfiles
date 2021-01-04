" Formatoptions
set formatoptions-=t       " Don't auto wrap text
set formatoptions+=c       " But do auto wrap comments
set formatoptions+=r       " Continue comments with <Enter>
set formatoptions-=o       " Do not continue comments with 'o' or 'O'
set formatoptions+=q       " Allow gq to format comments
set formatoptions+=j       " Remove comment leader when joining comment lines
set formatoptions-=2       " ... that's just weird

" <Tab> Behavior
set autoindent  " continue indentation to new line
set smarttab    " <Tab> behaves as expected
set shiftwidth=4        " autoindent uses 4 spaces
set tabstop=4        " <Tab> appears as 4 spaces
set softtabstop=4       " <Tab> behaves as 4 spaces
set expandtab   " <Tab> inserts 4 spaces
