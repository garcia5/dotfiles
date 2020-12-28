" Zoomer
let g:zoomer_expanded='false'
function! ToggleFocus()
    if( g:zoomer_expanded ==? 'false' )
        wincmd |
        wincmd _
        let g:zoomer_expanded = 'true'
    else
        wincmd =
        let g:zoomer_expanded = 'false'
    endif
endfunction
