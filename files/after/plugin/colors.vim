" Let colors display properly
set t_co=256
set termguicolors
let base16colorspace=256


set background=dark                                "  dark theme
if (v:false)                                       "  to toggle base16 colors
    if filereadable(expand("~/.vimrc_background"))
      source ~/.vimrc_background                   "  Make nvim colors match term colors
      AirlineTheme base16_snazzy                   "  Make statusline match nvim colors
    endif
else
    colorscheme base16-snazzy
    AirlineTheme base16_snazzy
endif

" Make FZF window match color scheme
let g:fzf_colors = {
    \ 'fg'      : ['fg', 'Normal'],
    \ 'bg'      : ['bg', 'Normal'],
    \ 'hl'      : ['fg', 'Comment'],
    \ 'fg+'     : ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+'     : ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+'     : ['fg', 'Statement'],
    \ 'info'    : ['fg', 'PreProc'],
    \ 'border'  : ['fg', 'Ignore'],
    \ 'prompt'  : ['fg', 'Conditional'],
    \ 'pointer' : ['fg', 'Exception'],
    \ 'marker'  : ['fg', 'Keyword'],
    \ 'spinner' : ['fg', 'Label'],
    \ 'header'  : ['fg', 'Comment'] }

" Fonts
let g:webdevicons_enable                    = 1
let g:airline_powerline_fonts               = 1
let g:webdevicons_enable_airline_statusline = 1
