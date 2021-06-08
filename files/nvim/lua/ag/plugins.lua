-- Init setup
vim.cmd 'packadd paq-nvim'                  -- Load package
local paq = require'paq-nvim'.paq           -- Import module and bind `paq` function

paq{'savq/paq-nvim', opt=true}              -- Let Paq manage itself

-- Lua basics
paq 'nvim-lua/popup.nvim'                   -- popup windows
paq 'nvim-lua/plenary.nvim'                 -- utility functions

-- Essentials
paq 'scrooloose/nerdcommenter'              -- Toggle comments
paq 'cohama/lexima.vim'                     -- auto pairs that JUST WORK (for real this time)
paq 'tpope/vim-surround'                    -- Surround
paq 'tpope/vim-repeat'                      -- ... and make them repeatable
paq 'godlygeek/tabular'                     -- Line it up
paq 'lukas-reineke/format.nvim'             -- format on save
paq 'nvim-telescope/telescope.nvim'         -- Fuzzy find _all_ the things

-- Look and feel
paq 'vim-airline/vim-airline'               -- pretty status/tab line

-- Colorschemes
paq 'gilgigilgil/anderson.vim'              -- anderson
paq 'srcery-colors/srcery-vim'              -- srecry
paq 'phanviet/vim-monokai-pro'              -- monokai
paq 'arzg/vim-corvine'                      -- corvine
paq 'chriskempson/base16-vim'               -- pretty colors
paq 'vim-airline/vim-airline-themes'        -- airline themes
paq 'shaunsingh/moonlight.nvim'             -- VSCode's moonlight theme in lua

-- Neovim HEAD features
paq 'neovim/nvim-lsp'                       -- LSP
paq 'folke/lsp-trouble.nvim'                -- Inline diagnostic info
paq 'neovim/nvim-lspconfig'                 -- basic configurations for LSP client
paq{'nvim-treesitter/nvim-treesitter',      -- treesitter
    run=function()
        vim.cmd [[TSUpdate]]
    end
}

-- Other nice to have
paq 'hrsh7th/nvim-compe'                    -- autocomplete
paq 'ray-x/lsp_signature.nvim'              -- signature help
paq 'hrsh7th/vim-vsnip'                     -- snippets
paq 'hrsh7th/vim-vsnip-integ'               -- ... with compe integration
paq 'tpope/vim-fugitive'                    -- git integration
paq {'lukas-reineke/indent-blankline.nvim', -- indent guides
    branch='lua'
}

-- NOTE
-- If :h <plugin> does not work, run :helptags ALL to add them
