-- Bootstrap packer if necessary
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Init setup
vim.cmd("packadd packer.nvim") -- load packer
local packer = require("packer")

packer.startup(function(use)
    -- Strictly required
    use("wbthomason/packer.nvim") -- let packer manage itself
    use("nvim-lua/popup.nvim") -- popup windows
    use("nvim-lua/plenary.nvim") -- utility functions

    -- Essentials
    use("tpope/vim-commentary") -- toggle comments
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                disable_filetype = { "TelescopePrompt", "dap-repl", "fugitive" },
                map_cr = true, -- send closing symbol to its own line
            })
        end,
    })
    use("tpope/vim-surround") -- surround
    use("tpope/vim-repeat") -- ... and make them repeatable
    use({
        "nvim-telescope/telescope.nvim", -- fuzzy find ALL the things
        config = function()
            require("ag.telescope")
        end,
    })

    -- Look and feel
    use("folke/lsp-colors.nvim") -- LSP colors that aren't built in
    use({
        "lewis6991/gitsigns.nvim", -- git signs in gutter + some useful keymaps
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                current_line_blame = false,
                current_line_blame_opts = {
                    delay = 1000,
                    virt_text = true,
                    virt_text_pos = "right_align",
                },
                update_debounce = 500,
                numhl = false,
            })
        end,
    })
    use({
        "nvim-lualine/lualine.nvim", -- statusline in lua
        requires = {
            "kyazdani42/nvim-web-devicons",
            opt = true,
        },
        config = function()
            require("ag.lualine")
        end,
    })

    -- Colorschemes
    use("chriskempson/base16-vim") -- pretty colors
    use("shaunsingh/moonlight.nvim") -- VSCode's moonlight theme in lua
    use("nxvu699134/vn-night.nvim") -- dark purple theme w/ treesitter support
    use({
        "EdenEast/nightfox.nvim", -- another lua colorscheme
        config = function()
            local nightfox = require("nightfox")
            nightfox.setup({
                transparent = true,
            })
            if string.match(vim.g.colors_name, ".+fox$") ~= nil then
                nightfox.load()
            end
        end,
    })
    use({
        "catppuccin/nvim", -- another another lua colorscheme
        config = function()
            local catp = require("catppuccin")
            catp.setup({
                transparent_background = true,
                term_colors = true,
                styles = {
                    comments = "italic",
                    functions = "NONE",
                    keywords = "NONE",
                    strings = "italic",
                    variables = "NONE",
                },
                integrations = {
                    gitsigns = true,
                    telescope = true,
                    treesitter = true,
                    cmp = true,
                    nvimtree = {
                        enabled = true,
                        show_root = false,
                    },
                    native_lsp = {
                        enabled = true,
                    },
                },
            })
            if vim.g.colors_name == "catppuccin" then
                catp.load()
            end
        end,
    })

    -- 0.5 features (lsp + treesitter)
    use("neovim/nvim-lspconfig") -- basic configurations for LSP client
    use("jose-elias-alvarez/null-ls.nvim") -- bridge between LSP client and external formatters/linters, not full fledged language servers
    use({
        "nvim-treesitter/nvim-treesitter", -- treesitter
        run = ":TSUpdate",
    })
    use("nvim-treesitter/nvim-treesitter-textobjects") -- custom text objects from treesitter

    -- Debuggers (still haven't figured out how to use this...)
    -- use("mfussenegger/nvim-dap")
    -- use({
    --     "rcarriga/nvim-dap-ui",
    --     requires = "mfussenegger/nvim-dap",
    -- })

    -- Other nice to have
    use({
        "editorconfig/editorconfig-vim", -- .editorconfig support
        config = function()
            vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
        end,
    })
    use({
        "tpope/vim-fugitive", -- git integration
        cmd = "Git",
    })
    use({
        "JoosepAlviste/nvim-ts-context-commentstring", -- commenting in vue files "just works"
        ft = {
            "vue",
            "typescript",
            "javascript",
        },
    })
    use({
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        ft = {
            "vue",
            "typescript",
            "javascript",
        },
    }) -- helpers for typescript development
    use({
        "kwkarlwang/bufresize.nvim", -- maintain buffer ratios on terminal resize
        config = function()
            require("bufresize").setup()
        end,
    })
    use({
        "hrsh7th/vim-vsnip", -- snippets
        ft = {
            "python",
            "javascript",
            "typescript",
            "vue",
            "lua",
        },
        config = function()
            vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snips")
        end,
    })
    use({
        "hrsh7th/nvim-cmp", -- autocomplete
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-vsnip",
            "onsails/lspkind-nvim",
            "lukas-reineke/cmp-under-comparator",
        },
        config = function()
            require("ag.completion")
            if vim.g.colors_name == "catppuccin" then
                -- catppuccin sets these automatically
                return
            end
            -- Use highlight groups!
            vim.cmd([[
                highlight! default link CmpItemAbbrMatch Boolean
                highlight! default link CmpItemAbbrMatchFuzzy Boolean

                highlight! default link CmpItemKindText TSEmphasis
                highlight! default link CmpItemKindMethod TSKeywordFunction
                highlight! default link CmpItemKindFunction TSKeywordFunction
                highlight! default link CmpItemKindConstructor TSConstructor
                highlight! default link CmpItemKindField TSField
                highlight! default link CmpItemKindVariable TSVariable
                highlight! default link CmpItemKindClass Structure
                highlight! default link CmpItemKindInterface Structure
                highlight! default link CmpItemKindModule Structure
                highlight! default link CmpItemKindProperty TSProperty
                highlight! default link CmpItemKindUnit Boolean
                highlight! default link CmpItemKindValue Character
                highlight! default link CmpItemKindEnum Structure
                highlight! default link CmpItemKindKeyword TSKeywordOperator
                highlight! default link CmpItemKindSnippet TSPunctSpecial
                highlight! default link CmpItemKindColor Constant
                highlight! default link CmpItemKindFile String
                highlight! default link CmpItemKindReference TSTextReference
                highlight! default link CmpItemKindFolder String
                highlight! default link CmpItemKindEnumMember TSField
                highlight! default link CmpItemKindConstant Constant
                highlight! default link CmpItemKindStruct Structure
                highlight! default link CmpItemKindEvent Conditional
                highlight! default link CmpItemKindOperator Operator
                highlight! default link CmpItemKindTypeParameter TSParameter
                ]])
        end,
        module = "cmp",
    })
    use({
        "godlygeek/tabular", -- line it up
        cmd = "Tab",
    })
    use({
        "kyazdani42/nvim-tree.lua", -- no more netrw
        config = function()
            require("nvim-tree").setup({
                auto_close = true,
                hijack_cursor = true,
                view = {
                    side = "left",
                    auto_resize = true,
                },
                git = {
                    enable = true,
                    ignore = false,
                },
            })
        end,
    })
    use({
        "mrjones2014/dash.nvim", -- ez open documentation
        run = "make install",
        config = function()
            vim.cmd([[ command! Dash Telescope dash search ]]) -- create command to lazy load on
        end,
        cmd = "Dash",
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf-like searching for telescope
        run = "make",
    })
    use({
        "stevearc/aerial.nvim", -- code outline
        config = function()
            require("aerial").setup({
                backends = { "treesitter" },
                max_width = 40,
                min_width = 20,
                close_behavior = "close",
            })
        end,
    })
end)
-- NOTE: If :h <plugin> does not work, run :helptags ALL to add them
