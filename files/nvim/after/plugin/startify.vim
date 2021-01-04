let g:startify_change_to_dir       = 0 " Don't change dir when I open a file
let g:startify_change_to_vcs_root  = 0 " In theory a good idea, but can be annoying. I usually do this myself anyway
let g:startify_fortune_use_unicode = 1 " Use unicode chars to look pretty
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
