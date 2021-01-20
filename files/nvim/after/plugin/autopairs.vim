augroup AutopairsDisable
    autocmd!
    autocmd FileType TelescopePrompt let b:lexima_disabled = 1
    autocmd FileType Term            let b:lexima_disabled = 1
    autocmd FileType netrw           let b:lexima_disabled = 1
    autocmd FileType fugitive        let b:lexima_disabled = 1
augroup end
