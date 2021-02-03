vim.cmd 'packadd paq-nvim'              -- Load package
local paq = require'paq-nvim'.paq       -- Import module and bind `paq` function

paq{'savq/paq-nvim', opt=true}          -- Let Paq manage itself

-- Lua basics
paq 'nvim-lua/popup.nvim'               -- popup windows
paq 'nvim-lua/plenary.nvim'             -- utility functions

paq 'scrooloose/nerdcommenter'          -- Toggle comments
paq 'vim-airline/vim-airline'           -- pretty status/tab line
paq 'nvim-telescope/telescope.nvim'     -- Fuzzy find _all_ the things
paq 'neovim/nvim-lsp'                   -- LSP
paq 'neovim/nvim-lspconfig'             -- basic configurations for LSP client
paq 'hrsh7th/nvim-compe'                -- autocomplete?
paq 'hrsh7th/vim-vsnip'                 -- snippets
paq 'hrsh7th/vim-vsnip-integ'           -- ... with better integration
paq {'nvim-treesitter/nvim-treesitter', -- treesitter
    hook=function()
        vim.cmd [[TSUpdate]]
    end
}
paq 'airblade/vim-gitgutter'            -- Git status in gutter
paq 'tpope/vim-surround'                -- Surround
paq 'tpope/vim-repeat'                  -- ... and make them repeatable
paq 'godlygeek/tabular'                 -- Line it up
paq 'lukas-reineke/format.nvim'         -- format on save
paq 'tpope/vim-fugitive'                -- git integration
paq 'cohama/lexima.vim'                 -- auto pairs that JUST WORK (for real this time)
paq 'mhinz/vim-sayonara'                -- sensible buffer cleanup

-- Colorschemes
paq 'gilgigilgil/anderson.vim'          -- anderson
paq 'srcery-colors/srcery-vim'          -- srecry
paq 'phanviet/vim-monokai-pro'          -- monokai
paq 'arzg/vim-corvine'                  -- corvine
paq 'chriskempson/base16-vim'           -- pretty colors
paq 'vim-airline/vim-airline-themes'    -- airline themes

-- NOTE
-- If :h <plugin> does not work, run :helptags ALL to add them
