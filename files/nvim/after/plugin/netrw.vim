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

