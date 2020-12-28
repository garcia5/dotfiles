" Format on save
augroup OnSave
    autocmd!
    autocmd BufWritePre * FormatWrite
augroup END

" Terminal setup
augroup term
    autocmd TermOpen * startinsert
    autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif
augroup end
