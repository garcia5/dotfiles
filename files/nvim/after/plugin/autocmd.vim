" Format on save
augroup OnSave
    autocmd!
    autocmd BufWritePre *.py,*.ts,*.vue FormatWrite
augroup END

" Terminal setup
augroup term
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * setlocal norelativenumber
    " Enter insert mode any time I enter the terminal
    autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif
    autocmd BufEnter * if winnr("$") == 1 && &buftype == 'terminal' | q | endif
augroup end

" exit vim if netrw is the last open buffer
autocmd BufEnter * if winnr("$") == 1 && &filetype == 'netrw' | q | endif

" Detect "TODO:" comments always
augroup vimrc_todo
    au!
    au Syntax * syn match MyTodo /\v<(NOTE|TODO):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyTodo Todo

" Auto-apply plugin changes
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
