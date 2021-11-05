function! termcmd#vert() abort
    let l:win_width = winwidth(0)
    let l:term_width = l:win_width / 3
    execute l:term_width .. "vs | term"
endfunction

function! termcmd#horiz() abort
    let l:win_height = winheight(0)
    let l:term_height = l:win_height / 3
    execute l:term_height .. "sp | term"
endfunction
