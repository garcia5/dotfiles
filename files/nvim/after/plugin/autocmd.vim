" Formatopts for ALL
au BufEnter * if &buftype != 'terminal' | set formatoptions=lcrqj | endif

" Format on save
augroup Format
    au!
    au BufWritePost *.lua FormatWrite
augroup end

" My dotfiles
augroup MyScripts
    au!
    au BufEnter .aliases set ft=bash
    au BufEnter .dotdash set ft=bash
augroup END

" Enable Rainbow Braces
autocmd BufReadPost * if exists (':RainbowParentheses') | RainbowParentheses | endif

" Terminal setup
augroup term
    au TermOpen * startinsert
    au TermOpen * setlocal nonumber
    au TermOpen * setlocal norelativenumber
    " Enter insert mode any time I enter the terminal
    au BufEnter * if &buftype == 'terminal' | startinsert | endif
    " Quit if only the terminal is left to avoid confusion
    au BufEnter * if winnr("$") == 1 && &buftype == 'terminal' | q | endif
augroup end

" Detect "TODO:" comments
" this doesn't work quite right
" augroup TodoHl
"     au!
"     " Regex:
"     " \v          -- Magic mode, normal regex special characters
"     " <           -- Beginning of word
"     " \zs         -- Begin the syntax match group
"     " (NOTE|TODO) -- highlight these!
"     " \ze         -- End the syntax match group
"     au Syntax * syn match MyTodo /\v<\zs(NOTE|TODO)\ze/
"           \ containedin=.*Comment,vimCommentTitle
" augroup END
" hi def link MyTodo Todo

" Auto-apply plugin changes
au BufWritePost plugins.lua source <afile> | PackerCompile

" Don't autopair in special buffers
augroup AutopairsDisable
    au!
    au FileType TelescopePrompt let b:lexima_disabled = 1
    au FileType Term            let b:lexima_disabled = 1
    au FileType netrw           let b:lexima_disabled = 1
    au FileType fugitive        let b:lexima_disabled = 1
    au FileType dap-repl        let b:lexima_disabled = 1
augroup end

" Disable editorconfig rules for special buffers
augroup EditorConfigDisable
    au!
    au FileType gitcommit let b:EditorConfig_disable = 1
augroup END

augroup DockerfileMatch
    au!
    au BufEnter Dockerfile.* set ft=dockerfile
augroup END
