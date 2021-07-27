-- Init setup
vim.cmd "packadd packer.nvim" -- load packer
local packer = require "packer"

packer.startup(
    function(use)
        -- Strictly required
        use "wbthomason/packer.nvim" -- let packer manage itself
        use "nvim-lua/popup.nvim"    -- popup windows
        use "nvim-lua/plenary.nvim"  -- utility functions

        -- Essentials
        use "scrooloose/nerdcommenter"      -- toggle comments
        use "cohama/lexima.vim"             -- auto pairs that JUST WORK (for real this time)
        use "tpope/vim-surround"            -- surround
        use "tpope/vim-repeat"              -- ... and make them repeatable
        use {
            "godlygeek/tabular",            -- line it up
            cmd = "Tab",
        }
        use "lukas-reineke/format.nvim"     -- format on save
        use "nvim-telescope/telescope.nvim" -- fuzzy find ALL the things

        -- Look and feel
        use {
            "lewis6991/gitsigns.nvim",               -- gitsigns
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require'gitsigns'.setup({
                    current_line_blame = false,
                    current_line_blame_delay = 1000,
                    update_debounce = 200,
                    numhl = true,
                })
            end,
        }
        use {
            "hoob3rt/lualine.nvim",                 -- statusline
             requires = {
                "kyazdani42/nvim-web-devicons",
                opt = true
            },
            config = function()
                require"lualine".setup{
                    theme = "auto",
                    sections = {
                        lualine_a = {"mode"},
                        lualine_b = {"filename"},
                        lualine_c = {"branch", "diff"},
                        lualine_x = {
                            {'diagnostics', sources = {'nvim_lsp'}},
                        },
                        lualine_y = {"filetype"},
                        lualine_z = {"location"},
                    },
                }
            end,
        }

        -- Colorschemes
        use "srcery-colors/srcery-vim"       -- srecry
        use "phanviet/vim-monokai-pro"       -- monokai
        use "arzg/vim-corvine"               -- corvine
        use "chriskempson/base16-vim"        -- pretty colors
        use "shaunsingh/moonlight.nvim"      -- VSCode's moonlight theme in lua
        use "nxvu699134/vn-night.nvim"       -- dark theme w/ treesitter support

        -- 0.5 features (lsp + treesitter)
        use "neovim/nvim-lsp"                             -- LSP
        use "neovim/nvim-lspconfig"                       -- basic configurations for LSP client
        use {
            "nvim-treesitter/nvim-treesitter",            -- treesitter
            run = ":TSUpdate",
        }
        use "nvim-treesitter/nvim-treesitter-textobjects" -- custom text objects from treesitter
        use "nvim-treesitter/nvim-treesitter-refactor"    -- nice refactoring helpers

        -- Other nice to have
        use {
            "hrsh7th/nvim-compe",                  -- autocomplete
            requires = {
                "hrsh7th/vim-vsnip",               -- ...w/ snippet integration
                "hrsh7th/vim-vsnip-integ",
            },
        }
        use "tpope/vim-fugitive"                   -- git integration
        use {
            "lukas-reineke/indent-blankline.nvim", -- indent guides
            ft = {"vue", "yaml", "html", "json"},
        }
    end
)
-- NOTE
-- If :h <plugin> does not work, run :helptags ALL to add them
