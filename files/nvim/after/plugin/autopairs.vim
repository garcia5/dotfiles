" No more autopairs
" skip over closing grouping symbols
inoremap <expr> ] CharNext(']') ? '<Right>' : ']'
inoremap <expr> ) CharNext(')') ? '<Right>' : ')'
inoremap <expr> } CharNext('}') ? '<Right>' : '}'
" auto complete matching symbols (if necessary)
function! CharNext(char)
    return match(getline('.')[getpos('.')[2] - 1], a:char) !=? -1
endfunction
inoremap <expr> [ CharNext('\S') == '1' ? '[' : '[]<Left>'
inoremap <expr> ( CharNext('\S') == '1' ? '(' : '()<Left>'
inoremap <expr> { CharNext('\S') == '1' ? '{' : '{}<Left>'
" auto expand grouping symbols
inoremap [<CR> []<Left><CR><CR><Up><Tab>
inoremap (<CR> ()<Left><CR><CR><Up><Tab>
inoremap {<CR> {}<Left><CR><CR><Up><Tab>
