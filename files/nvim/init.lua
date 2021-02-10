-- Essentials
vim.g.mapleader         = " "
vim.g.python3_host_prog = vim.fn.exepath('python3')
vim.g.bulitin_lsp       = true

require('ag') -- load my lua configs

-- Behaviors
vim.wo.number     = true                                     -- absolute numbers for easier screen sharing
vim.wo.cursorline = true                                     -- highlight current line
vim.o.belloff     = 'all'                                    -- NO BELLS!
vim.o.completeopt = 'menu,menuone,noselect'                  -- ins-completion how ~I like it~ vsnip likes it
vim.o.swapfile    = false                                    -- swap files annoy me
vim.o.inccommand  = 'split'                                  -- preview %s commands in a split window as I type
vim.o.hidden      = true                                     -- move away from unsaved buffers
vim.o.updatetime  = 100                                      -- stop typing quickly
vim.o.undofile    = true                                     -- keep track of my 'undo's between sessions
vim.o.grepprg     = 'rg --vimgrep --smart-case --no-heading' -- search with rg
vim.o.grepformat  = '%f:%l:%c:%m'                            -- filename:line number:column number:error message

-- Look and feel
vim.wo.list                    = true                                               -- show list chars
vim.o.listchars                = 'tab:»·,eol:↵,nbsp:␣,extends:…,precedes:…,trail:·' -- these list chars
vim.o.scrolloff                = 10                                                 -- padding between cursor and top/bottom of window
vim.wo.foldmethod              = 'marker'                                           -- fold on {{{...}}} by default
vim.wo.foldlevel               = 99                                                 -- default to all folds open
vim.g.foldlevelstart           = 99                                                 -- open files with all folds open
vim.o.splitright               = true                                               -- prefer vsplitting to the right
vim.o.splitbelow               = true                                               -- prefer splitting below
vim.wo.wrap                    = false                                              -- don't wrap my text
vim.g.python_recommended_style = 0                                                  -- I know how I like my python

-- Searching
vim.cmd([[set path +=.,**]]) -- search from project root
vim.o.wildmenu      = true   -- tab complete on command line
vim.o.ignorecase    = true   -- case insensitive search...
vim.o.smartcase     = true   -- unless I use caps
vim.o.hlsearch      = true   -- highlight matching text
vim.o.incsearch     = true   -- search while I type
vim.o.wildignore    = 'term:///*,*/.git/index'
