vim.cmd 'packadd paq-nvim'            -- Load package
local paq = require'paq-nvim'.paq     -- Import module and bind `paq` function

paq{'savq/paq-nvim', opt=true}        -- Let Paq manage itself

-- Lua basics
paq 'nvim-lua/popup.nvim'             -- popup windows
paq 'nvim-lua/plenary.nvim'           -- utility functions

paq 'scrooloose/nerdcommenter'        -- Toggle comments
paq 'vim-airline/vim-airline'         -- pretty status/tab line
paq 'junegunn/fzf'                    -- make sure we always have a good FZF
paq 'junegunn/fzf.vim'                -- better fzf integration
paq 'neovim/nvim-lsp'                 -- LSP
paq 'neovim/nvim-lspconfig'           -- basic configurations for LSP client
paq 'gfanto/fzf-lsp.nvim'             -- fuzzy search LSP objects with fzf
paq 'nvim-lua/completion-nvim'        -- autocomplete
paq {'nvim-treesitter/nvim-treesitter', hook=function() vim.cmd [[TSUpdate]] end} -- treesitter
paq 'airblade/vim-gitgutter'          -- Git status in gutter
paq 'tpope/vim-surround'              -- Surround
paq 'tpope/vim-repeat'                -- ... and make them repeatable
paq 'godlygeek/tabular'               -- Line it up
paq 'lukas-reineke/format.nvim'       -- format on save
paq 'tpope/vim-fugitive'              -- git integration
paq 'RRethy/vim-illuminate'           -- highlight occurrances of symbol under cursor

-- Colorschemes
paq 'gilgigilgil/anderson.vim'        -- anderson color scheme
paq 'srcery-colors/srcery-vim'        -- srecry color scheme
paq 'phanviet/vim-monokai-pro'        -- monokai pro color scheme
paq 'arzg/vim-corvine'                -- corvine
paq 'chriskempson/base16-vim'         -- pretty colors
paq 'vim-airline/vim-airline-themes'  -- airline themes

-- NOTE
-- If :h <plugin> does not work, run :helptags ALL to add them
