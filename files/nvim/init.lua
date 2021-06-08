-- Essentials
vim.g.mapleader         = " "
vim.g.python3_host_prog = vim.fn.exepath('python3')
vim.g.bulitin_lsp       = true

require('ag') -- load my lua configs

-- Behaviors
vim.opt.belloff     = 'all'                                     -- NO BELLS!
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}           -- ins-completion how ~I like it~ vsnip likes it
vim.opt.swapfile    = false                                     -- swap files annoy me
vim.opt.inccommand  = 'split'                                   -- preview %s commands in a split window as I type
vim.opt.hidden      = true                                      -- move away from unsaved buffers
vim.opt.updatetime  = 100                                       -- stop typing quickly
vim.opt.undofile    = true                                      -- keep track of my 'undo's between sessions
vim.opt.grepprg     = 'rg --vimgrep --smart-case --no-heading'  -- search with rg
vim.opt.grepformat  = '%f:%l:%c:%m'                             -- filename:line number:column number:error message
vim.opt.mouse       = 'n'                                       -- use mouse to scroll around (hold shift to disable)

-- Look and feel
vim.opt.number                   = true     -- absolute numbers...
vim.opt.relativenumber           = true     -- but only on the current line
vim.opt.cursorline               = true     -- highlight current line
vim.opt.list                     = true     -- show list chars
vim.opt.listchars                = {        -- these list chars
    tab                          = '»·',
    eol                          = '↵',
    nbsp                         = '␣',
    extends                      = '…',
    precedes                     = '…',
    trail                        = '·',
}
vim.opt.scrolloff                = 10       -- padding between cursor and top/bottom of window
vim.opt.foldmethod               = 'marker' -- fold on {{{...}}} by default
vim.opt.foldlevel                = 99       -- default to all folds open
vim.opt.foldlevelstart           = 99       -- open files with all folds open
vim.opt.splitright               = true     -- prefer vsplitting to the right
vim.opt.splitbelow               = true     -- prefer splitting below
vim.opt.wrap                     = false    -- don't wrap my text
vim.g.python_recommended_style   = 0        -- I know how I like my python

-- Searching
vim.opt.path:append('.,**')  -- search from project root
vim.opt.wildmenu      = true -- tab complete on command line
vim.opt.ignorecase    = true -- case insensitive search...
vim.opt.smartcase     = true -- unless I use caps
vim.opt.hlsearch      = true -- highlight matching text
vim.opt.incsearch     = true -- search while I type
