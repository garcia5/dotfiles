" Jump forward or backward
imap <expr> <C-j> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<C-j>'
imap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-k>'

" To edit new snippets, run :VsnipOpen in corresponding filetype, or edit
" ~/.config/nvim/snips/<fieltype>.json
