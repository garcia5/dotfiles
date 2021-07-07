-- Init setup
vim.cmd 'packadd paq-nvim'                        -- load package
local paq = require'paq-nvim'.paq                 -- import module and bind `paq` function

paq{'savq/paq-nvim', opt = true}                    -- let Paq manage itself

-- Lua basics
paq 'nvim-lua/popup.nvim'                         -- popup windows
paq 'nvim-lua/plenary.nvim'                       -- utility functions

-- Essentials
paq 'scrooloose/nerdcommenter'                    -- toggle comments
paq 'cohama/lexima.vim'                           -- auto pairs that JUST WORK (for real this time)
paq 'tpope/vim-surround'                          -- surround
paq 'tpope/vim-repeat'                            -- ... and make them repeatable
paq 'godlygeek/tabular'                           -- line it up
paq 'lukas-reineke/format.nvim'                   -- format on save
paq 'nvim-telescope/telescope.nvim'               -- fuzzy find ALL the things

-- Look and feel
paq 'vim-airline/vim-airline'                     -- pretty status/tab line

-- Colorschemes
paq 'srcery-colors/srcery-vim'                    -- srecry
paq 'phanviet/vim-monokai-pro'                    -- monokai
paq 'arzg/vim-corvine'                            -- corvine
paq 'chriskempson/base16-vim'                     -- pretty colors
paq 'vim-airline/vim-airline-themes'              -- airline themes
paq 'shaunsingh/moonlight.nvim'                   -- VSCode's moonlight theme in lua

-- 0.5 features
paq 'neovim/nvim-lsp'                             -- LSP
paq 'folke/lsp-trouble.nvim'                      -- inline diagnostic info
paq 'doums/lsp_status'                            -- show lsp activity in status bar
paq 'neovim/nvim-lspconfig'                       -- basic configurations for LSP client
paq{'nvim-treesitter/nvim-treesitter',            -- treesitter
    run = function()
        vim.cmd [[TSUpdate]]
    end
}
paq 'nvim-treesitter/nvim-treesitter-textobjects' -- custom text objects from treesitter
paq 'nvim-treesitter/nvim-treesitter-refactor'    -- nice refactoring helpers

-- Other nice to have
paq 'hrsh7th/nvim-compe'                          -- autocomplete
paq 'hrsh7th/vim-vsnip'                           -- snippets
paq 'hrsh7th/vim-vsnip-integ'                     -- ... with compe integration
paq 'tpope/vim-fugitive'                          -- git integration
paq 'lukas-reineke/indent-blankline.nvim'         -- indent guides
paq{'nvim-telescope/telescope-fzf-native.nvim',   -- fzf sorting for telescope
    run = 'make'
}

-- NOTE
-- If :h <plugin> does not work, run :helptags ALL to add them
