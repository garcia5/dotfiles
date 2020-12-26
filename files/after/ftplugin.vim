" Formatoptions
set fo-=t       " Don't auto wrap text
set fo+=c       " But do auto wrap comments
set fo+=r       " Continue comments with <Enter>
set fo-=o       " Do not continue comments with 'o' or 'O'
set fo+=q       " Allow gq to format comments
set fo+=j       " Remove comment leader when joining comment lines
set fo-=2       " ... that's just weird

" <Tab> Behavior
set autoindent  " continue indentation to new line
set smartindent " make grouping symbol indentation match
set smarttab    " <Tab> behaves as expected
set sw=4        " autoindent uses 4 spaces
set ts=4        " <Tab> appears as 4 spaces
set sts=4       " <Tab> behaves as 4 spaces
set expandtab   " <Tab> inserts 4 spaces
