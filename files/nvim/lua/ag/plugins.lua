vim.cmd 'packadd paq-nvim'         -- Load package
local paq = require'paq-nvim'.paq  -- Import module and bind `paq` function
paq{'savq/paq-nvim', opt=true}     -- Let Paq manage itself

paq 'scrooloose/nerdcommenter'
paq 'vim-airline/vim-airline'
paq 'vim-airline/vim-airline-themes'
-- use brew installed FZF for nvim
-- Same as doing rtp+='/usr/local/bin/fzf'
vim.g.rtp = '/usr/local/bin/fzf'
-- better fzf integration
paq 'junegunn/fzf.vim'
-- LSP
paq 'neovim/nvim-lsp'
paq 'neovim/nvim-lspconfig'
paq 'nvim-lua/completion-nvim'
paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'
paq 'nvim-treesitter/nvim-treesitter'
-- Git status in gutter
paq {'airblade/vim-gitgutter', opt = true}
-- Surround
paq 'tpope/vim-surround'
-- ... and make them repeatable
paq 'tpope/vim-repeat'
-- Line it up
paq {'godlygeek/tabular', opt = true}
-- format on save
paq 'lukas-reineke/format.nvim'
-- git integration
paq {'tpope/vim-fugitive'}

-- Colorschemes
-- anderson color scheme
paq 'gilgigilgil/anderson.vim'
-- srecry color scheme
paq 'srcery-colors/srcery-vim'
-- monokai pro color scheme
paq 'phanviet/vim-monokai-pro'
-- corvine
paq 'arzg/vim-corvine'
-- pretty colors
paq 'chriskempson/base16-vim'
