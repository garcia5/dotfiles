" No more autopairs
" skip over closing grouping symbols
inoremap <expr> ] getline('.')[getpos('.')[2] - 1] == ']' ? '<Right>' : ']'
inoremap <expr> ) getline('.')[getpos('.')[2] - 1] == ')' ? '<Right>' : ')'
inoremap <expr> } getline('.')[getpos('.')[2] - 1] == '}' ? '<Right>' : '}'
" auto complete matching symbols (if necessary)
function! CharNext()
    return match(getline('.')[getpos('.')[2] - 1], '\S') !=? -1
endfunction
inoremap <expr> [ CharNext() == '1' ? '[' : '[]<Left>'
inoremap <expr> ( CharNext() == '1' ? '(' : '()<Left>'
inoremap <expr> { CharNext() == '1' ? '{' : '{}<Left>'
" auto expand grouping symbols
inoremap [<CR> []<Left><CR><CR><Up><Tab>
inoremap (<CR> ()<Left><CR><CR><Up><Tab>
inoremap {<CR> {}<Left><CR><CR><Up><Tab>
