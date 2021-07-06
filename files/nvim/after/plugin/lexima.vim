" Work nicely with nvim-compe
" https://github.com/hrsh7th/nvim-compe#mappings
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()

" Don't autopair in special buffers
augroup AutopairsDisable
    autocmd!
    autocmd FileType TelescopePrompt let b:lexima_disabled = 1
    autocmd FileType Term            let b:lexima_disabled = 1
    autocmd FileType netrw           let b:lexima_disabled = 1
    autocmd FileType fugitive        let b:lexima_disabled = 1
augroup end
