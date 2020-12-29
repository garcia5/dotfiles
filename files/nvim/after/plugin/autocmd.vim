" Format on save
augroup OnSave
    autocmd!
    autocmd BufWritePre * FormatWrite
augroup END

" Terminal setup
augroup term
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * setlocal norelativenumber
    " Enter insert mode any time I enter the terminal
    autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif
augroup end

" exit vim if netrw is the last open buffer
autocmd BufEnter * if winnr("$") == 1 && &filetype == 'netrw' | q | endif
