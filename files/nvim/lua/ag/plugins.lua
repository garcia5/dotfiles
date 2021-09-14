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
        use {
            "Murtaza-Udaipurwala/gruvqueen", -- gruvbux, but in lua
            config = function ()
                if vim.g.colors_name ~= 'gruvqueen' then
                    return
                end
                require'gruvqueen'.setup({
                    disable_bold = false,
                    italic_keywords = false,
                    italic_functions = false,
                    italic_variables = false,
                    italic_comments = true,
                    style = 'material',
                })
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
        use "tpope/vim-fugitive"                                                          -- git integration
        use "p00f/nvim-ts-rainbow"                                                        -- rainbow braces
        --use {
        --    "andweeb/presence.nvim",                                                      -- discord for shits
        --    config = function ()
        --        require'presence':setup({
        --            editing_text        = ":thinking:",
        --            file_explorer_text  = "",
        --            git_commit_text     = "",
        --            plugin_manager_text = "",
        --            reading_text        = "",
        --            workspace_text      = "",
        --            line_number_text    = "",
        --        })
        --    end
        --}
        use {
            "hrsh7th/nvim-compe",                                                         -- autocomplete
            requires = {
                "hrsh7th/vim-vsnip",                                                      -- ...w/ snippet integration
                "hrsh7th/vim-vsnip-integ",
            },
        }
        use {
            "godlygeek/tabular",                                                          -- line it up
            cmd = "Tab",
        }
        use {
            "lukas-reineke/indent-blankline.nvim",                                        -- indent guides
            config = function()
                require'indent_blankline'.setup({
                    use_treesitter          = false,
                    show_first_indent_level = false,
                    filetype_exclude        = {'help', 'telescope', 'fugitive', 'netrw'},
                    buftype_exclude         = {'terminal'},
                    char                    = '▏',
                    char_highlight          = 'comment',
                    filetype                = {'yaml', 'vue', 'html', 'json'},
                })
            end,
        }
        use {
            "editorconfig/editorconfig-vim",                                              -- .editorconfig support
            config = function ()
                vim.g.EditorConfig_exclude_patterns = {
                    'fugitive://.*', 'term://.*'
                }
            end
        }
        use {
            "kyazdani42/nvim-tree.lua",                                                   -- no more netrw
            config = function ()
                vim.g.nvim_tree_side = 'left'
            end
        }
    end
)
-- NOTE: If :h <plugin> does not work, run :helptags ALL to add them
