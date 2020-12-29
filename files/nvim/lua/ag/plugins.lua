vim.cmd 'packadd paq-nvim'         -- Load package
local paq = require'paq-nvim'.paq  -- Import module and bind `paq` function
paq{'savq/paq-nvim', opt=true}     -- Let Paq manage itself

paq 'scrooloose/nerdcommenter'
paq 'vim-airline/vim-airline'
paq 'vim-airline/vim-airline-themes'
-- make sure we always have a good FZF
paq 'junegunn/fzf'
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
paq 'airblade/vim-gitgutter'
-- Surround
paq 'tpope/vim-surround'
-- ... and make them repeatable
paq 'tpope/vim-repeat'
-- Line it up
paq 'godlygeek/tabular'
-- format on save
paq 'lukas-reineke/format.nvim'
-- git integration
paq 'tpope/vim-fugitive'
-- that fancy start screen with the cow
paq 'mhinz/vim-startify'

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

-- NOTE
-- If :h <plugin> does not work, run :helptags ALL to add them
