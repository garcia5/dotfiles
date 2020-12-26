" Format on save
augroup OnSave
    autocmd!
    autocmd BufWritePre * FormatWrite
augroup END

" Netrw
" disable header
let g:netrw_banner = 0
" look like nerdtree
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" skinnier
let g:netrw_winsize = 20
" automatically hide dotfiles/folders
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide=ghregex
let g:NetrwIsOpen=0
" let it toggle
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction
" Navigate left instead of refreshing
au Filetype netrw nmap <buffer> <silent> <C-l> <C-w>l

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

" Zoomer
function! ToggleFocus()
    let g:expanded='false'
    if( g:expanded ==? 'false' )
        wincmd |
        wincmd _
        let g:expanded = 'true'
    else
        wincmd =
        let g:expanded = 'false'
    endif
endfunction
nnoremap <silent> <Leader>z :call ToggleFocus()<CR>

" Terminal setup
augroup term
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif
augroup end
