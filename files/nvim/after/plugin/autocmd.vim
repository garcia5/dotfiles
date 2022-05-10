" Formatopts for ALL
au BufEnter * if &buftype != 'terminal' && &ft != 'gitcommit' | set formatoptions=lcrqj | endif

" Format on save
augroup Format
    au!
    au BufWritePre *.lua lua vim.lsp.buf.formatting_sync()
    au BufWritePre *.ts call TsFormat()
    au BufWritePre *.js EslintFixAll
    au BufWritePre *.vue call VueFormat()
augroup end

function! VueFormat() abort
    " let language server try first, before eslint fixes minor issues
    lua vim.lsp.buf.formatting_sync()
    EslintFixAll
endfunction

function! TsFormat() abort
    lua vim.lsp.buf.formatting_seq_sync(nil, nil, {"tsserver", "null-ls"})
    EslintFixAll
endfunction

function! JsFormat() abort
    lua vim.lsp.buf.formatting_sync()
    EslintFixAll
endfunction

" My dotfiles
augroup MyScripts
    au!
    au BufEnter .aliases set ft=bash
    au BufEnter .dotdash set ft=bash
augroup END

" Terminal setup
augroup term
    au TermOpen * startinsert
    au TermOpen * setlocal nonumber
    au TermOpen * setlocal norelativenumber
    au TermOpen * setlocal nocursorline
    au TermOpen * setlocal signcolumn=no
    au TermOpen * let b:indent_blankline_enabled=v:false
    " Enter insert mode any time I enter the terminal
    au BufEnter * if &buftype == 'terminal' | startinsert | endif
    " Quit if only the terminal is left to avoid confusion
    au BufEnter * if winnr("$") == 1 && &buftype == "terminal" | q | endif
augroup end

" Auto-apply plugin changes
au BufWritePost plugins.lua source <afile> | PackerCompile

" Disable editorconfig rules for special buffers
augroup EditorConfigDisable
    au!
    au FileType gitcommit let b:EditorConfig_disable = 1
augroup END

augroup DockerfileMatch
    au!
    au BufEnter Dockerfile.* set ft=dockerfile
augroup END

" Show cursorline for file explorer
augroup NvimTree
    au!
    " Highlight current line (here only)
    au BufEnter * if &ft == "NvimTree" | setlocal cursorline | endif
    " Quit if NvimTree is the only thing open
    au BufEnter * if winnr("$") == 1 && &ft == "NvimTree" | q | endif
augroup END

augroup KittyConfig
    au!
    au BufReadPost kitty.conf setlocal foldlevel=0 " open kitty config with all folds closed
augroup END

" Aerial specific mapping
augroup Aerial
    au!
    au FileType aerial nnoremap <buffer> q :q<CR>
augroup END
