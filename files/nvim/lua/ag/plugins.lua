-- Bootstrap packer if necessary
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
end

-- Init setup
vim.cmd "packadd packer.nvim" -- load packer
local packer = require("packer")

packer.startup(
    function(use)
        -- Strictly required
        use "wbthomason/packer.nvim" -- let packer manage itself
        use "nvim-lua/popup.nvim" -- popup windows
        use "nvim-lua/plenary.nvim" -- utility functions

        -- Essentials
        use "tpope/vim-commentary" -- toggle comments
        use {
            "cohama/lexima.vim", -- auto pairs that JUST WORK (for real this time)
            config = function()
                vim.g.lexima_accept_pum_with_enter = false
            end
        }
        use "tpope/vim-surround" -- surround
        use "tpope/vim-repeat" -- ... and make them repeatable
        use "nvim-telescope/telescope.nvim" -- fuzzy find ALL the things

        -- Look and feel
        use "folke/lsp-colors.nvim" -- LSP colors that aren't built in
        use {
            "junegunn/rainbow_parentheses.vim", -- rainbow braces
            config = function()
                vim.g["rainbow#pairs"] = {
                    {"[", "]"},
                    {"{", "}"},
                    {"(", ")"}
                }
                vim.g["rainbow#blacklist"] = {145} -- disable white
            end
        }
        use {
            "lewis6991/gitsigns.nvim", -- git signs in gutter + some useful keymaps
            requires = {"nvim-lua/plenary.nvim"},
            config = function()
                require "gitsigns".setup(
                    {
                        current_line_blame = false,
                        current_line_blame_opts = {
                            delay = 1000,
                            virt_text = true,
                            virt_text_pos = "right_align"
                        },
                        update_debounce = 500,
                        numhl = true
                    }
                )
            end
        }
        use {
            "nvim-lualine/lualine.nvim", -- statusline in lua
            requires = {
                "kyazdani42/nvim-web-devicons",
                opt = true
            }
        }
        use "MunifTanjim/nui.nvim" -- UI components

        -- Colorschemes
        use "chriskempson/base16-vim" -- pretty colors
        use "shaunsingh/moonlight.nvim" -- VSCode's moonlight theme in lua
        use "nxvu699134/vn-night.nvim" -- dark purple theme w/ treesitter support
        use "EdenEast/nightfox.nvim" -- another lua colorscheme
        use {
            "Pocco81/Catppuccino.nvim", -- another another lua colorscheme
            config = function()
                if vim.g.colors_name ~= "catppuccino" then
                    return
                end
                local catp = require("catppuccino")
                catp.setup(
                    {
                        colorscheme = "dark_catppuccino",
                        transparency = true,
                        styles = {
                            comments = "italic",
                            functions = "NONE",
                            keywords = "NONE",
                            strings = "NONE",
                            variables = "NONE"
                        },
                        integrations = {
                            gitsigns = true,
                            gitgutter = true,
                            telescope = true,
                            treesitter = true,
                            nvimtree = {
                                enabled = true,
                                show_root = true
                            },
                            native_lsp = {
                                enabled = true
                            }
                        }
                    }
                )
                catp.load()
            end
        }

        -- 0.5 features (lsp + treesitter)
        use "neovim/nvim-lsp" -- LSP
        use "neovim/nvim-lspconfig" -- basic configurations for LSP client
        use {
            "nvim-treesitter/nvim-treesitter", -- treesitter
            run = ":TSUpdate"
        }
        use "nvim-treesitter/nvim-treesitter-textobjects" -- custom text objects from treesitter

        -- Debuggers
        use "mfussenegger/nvim-dap"
        use {
            "rcarriga/nvim-dap-ui",
            requires = "mfussenegger/nvim-dap"
        }

        -- Other nice to have
        use "editorconfig/editorconfig-vim" -- .editorconfig support
        use {
            "tpope/vim-fugitive", -- git integration
            cmd = "Git"
        }
        use {
            "JoosepAlviste/nvim-ts-context-commentstring", -- commenting in vue files "just works"
            ft = {
                "vue",
                "typescript",
                "javascript"
            }
        }
        use {
            "kwkarlwang/bufresize.nvim", -- maintain buffer ratios on terminal resize
            config = function()
                require "bufresize".setup()
            end
        }
        use {
            "hrsh7th/vim-vsnip", -- snippets
            ft = {
                "python",
                "javascript",
                "typescript",
                "vue",
                "lua"
            }
        }
        use {
            "hrsh7th/nvim-cmp", -- autocomplete
            requires = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-vsnip",
                "onsails/lspkind-nvim",
                "lukas-reineke/cmp-under-comparator"
            }
        }
        use {
            "godlygeek/tabular", -- line it up
            cmd = "Tab"
        }
        use {
            "kyazdani42/nvim-tree.lua", -- no more netrw
            config = function()
                require "nvim-tree".setup(
                    {
                        view = {
                            side = "left",
                            auto_resize = true
                        }
                    }
                )
            end,
            cmd = {
                "NvimTreeToggle",
                "NvimTreeFindFile"
            }
        }
        use {
            "mrjones2014/dash.nvim", -- ez open documentation
            run = "make install",
            config = function()
                vim.cmd [[ command! Dash Telescope dash search ]] -- create command to lazy load on
            end,
            cmd = "Dash"
        }
        use {
            "lukas-reineke/format.nvim",
            config = function()
                require("format").setup(
                    {
                        lua = {
                            {
                                cmd = {
                                    function(file)
                                        return string.format("luafmt -l %s -w replace %s", vim.bo.textwidth, file)
                                    end
                                }
                            }
                        }
                    }
                )
            end,
            cmd = {
                "FormatWrite"
            }
        }
    end
)
-- NOTE: If :h <plugin> does not work, run :helptags ALL to add them
