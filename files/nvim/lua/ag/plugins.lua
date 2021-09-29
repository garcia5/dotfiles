-- Bootstrap packer if necessary
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end

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
        use "scrooloose/nerdcommenter"               -- toggle comments
        use {
            "cohama/lexima.vim",                     -- auto pairs that JUST WORK (for real this time)
            config = function ()
                vim.g.lexima_no_default_rules = true
                vim.fn['lexima#set_default_rules']()
            end
        }
        use "tpope/vim-surround"                     -- surround
        use "tpope/vim-repeat"                       -- ... and make them repeatable
        use "lukas-reineke/format.nvim"              -- format on save
        use "nvim-telescope/telescope.nvim"          -- fuzzy find ALL the things

        -- Look and feel
        use "folke/lsp-colors.nvim"                  -- LSP colors that aren't built in
        use {
            "lewis6991/gitsigns.nvim",               -- git signs in gutter + some useful keymaps
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require'gitsigns'.setup({
                    current_line_blame = false,
                    current_line_blame_opts = {
                        delay = 1000,
                        virt_text = true,
                        virt_text_pos = 'right_align',
                    },
                    update_debounce = 200,
                    numhl = true,
                })
            end,
        }
        use {
            "hoob3rt/lualine.nvim",                  -- statusline in lua
             requires = {
                "kyazdani42/nvim-web-devicons",
                opt = true
            },
        }

        -- Colorschemes
        use "chriskempson/base16-vim"        -- pretty colors
        use "shaunsingh/moonlight.nvim"      -- VSCode's moonlight theme in lua
        use "nxvu699134/vn-night.nvim"       -- dark purple theme w/ treesitter support
        use "EdenEast/nightfox.nvim"         -- another lua colorscheme
        use {
            "Pocco81/Catppuccino.nvim",      -- another another lua colorscheme
            config = function ()
                if vim.g.colors_name ~= 'catppuccino' then
                    return
                end
                local catp = require('catppuccino')
                catp.setup({
                    colorscheme = "dark_catppuccino",
                    styles = {
                        comments = "italic",
                        functions = "NONE",
                        keywords = "NONE",
                    },
                    integrations = {
                        telescope = true,
                        treesitter = true,
                        native_lsp = {
                            enabled = true,
                            styles = {
                                errors = "italic",
                                warnings = "italic",
                                information = "italic",
                                hints = "italic",
                            },
                        },
                        gitsigns = true,
                    },
                })
                catp.load()
            end
        }

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
        use "tpope/vim-fugitive"                                                             -- git integration
        use {
            "kwkarlwang/bufresize.nvim",                                                     -- maintain buffer ratios on terminal resize
            config = function ()
                require'bufresize'.setup()
            end
        }
        use "hrsh7th/vim-vsnip"                                                              -- snippets
        use {
            "hrsh7th/nvim-cmp",                                                              -- autocomplete
            requires = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-vsnip",
                "onsails/lspkind-nvim",
            },
        }
        use {
            "godlygeek/tabular",                                                             -- line it up
            cmd = "Tab",
        }
        use {
            "lukas-reineke/indent-blankline.nvim",                                           -- indent guides
            config = function ()
                vim.cmd [[highlight IndentBlanklineIndent guifg=#3c425d]]
                require'indent_blankline'.setup({
                    show_trailing_blankline_indent = false,
                    use_treesitter                 = true,
                    show_first_indent_level        = false,
                    buftype_exclude                = {'terminal'},
                    filetype                       = {'yaml', 'vue', 'html', 'json', 'lua'},
                    show_current_context           = true,
                    char_highlight_list            = {'IndentBlanklineIndent'}
                })
            end,
        }
        use {
            "editorconfig/editorconfig-vim",                                                 -- .editorconfig support
            config = function ()
                vim.g.EditorConfig_exclude_patterns = {
                    'fugitive://.*', 'term://.*'
                }
            end
        }
        use {
            "kyazdani42/nvim-tree.lua",                                                      -- no more netrw
            config = function ()
                require'nvim-tree'.setup({
                    lsp_diagnostics = true,
                    view = {
                        side = 'left',
                        auto_resize = true,
                    },
                })
            end
        }
    end
)
-- NOTE: If :h <plugin> does not work, run :helptags ALL to add them
