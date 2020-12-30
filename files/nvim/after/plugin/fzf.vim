" Make :Rg command search file contents, not file name
" https://github.com/junegunn/fzf.vim/issues/714
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
