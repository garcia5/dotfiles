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
    use({
        "numToStr/Comment.nvim", -- "smart" (ts powered) commenting
        config = function()
            require("Comment").setup({
                pre_hook = function(ctx)
                    -- Use commentstring plugins for vue SFCs
                    if vim.bo.filetype == "vue" then
                        local U = require("Comment.utils")

                        -- Detemine whether to use linewise or blockwise commentstring
                        local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

                        -- Determine the location where to calculate commentstring from
                        local location = nil
                        if ctx.ctype == U.ctype.block then
                            location = require("ts_context_commentstring.utils").get_cursor_location()
                        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                            location = require("ts_context_commentstring.utils").get_visual_start_location()
                        end

                        return require("ts_context_commentstring.internal").calculate_commentstring({
                            key = type,
                            location = location,
                        })
                    end
                end,
            })
        end,
    })
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
            require("ag.plugin-conf.telescope")
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
                attach_to_untracked = false,
                on_attach = function(bufnr)
                    local keymap_opts = { silent = true, noremap = true }
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "=", "<cmd>Gitsigns preview_hunk<CR>", keymap_opts)
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>rh", "<cmd>Gitsigns reset_hunk<CR>", keymap_opts)
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>sh", "<cmd>Gitsigns stage_hunk<CR>", keymap_opts)
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>gn", "<cmd>Gitsigns next_hunk<CR>", keymap_opts)
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>gp", "<cmd>Gitsigns prev_hunk<CR>", keymap_opts)
                end,
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
            require("ag.plugin-conf.lualine")
        end,
    })
    use("p00f/nvim-ts-rainbow") -- rainbow braces (and tags) powered by treesitter
    use({
        "mhinz/vim-startify", -- start menu
        config = function()
            vim.g.startify_session_dir = "~/.sesh/"
            vim.g.startify_change_to_dir = 0 -- don't go to the selected file's directory
            vim.g.startify_change_to_vcs_root = 1 -- go to project root
            vim.g.startify_change_cmd = "cd" -- ... and do it for the whole vim instance
            vim.g.startify_commands = {
                { f = { "Find Files", "Telescope find_files" } },
                { g = { "Live Grep", "Telescope live_grep" } },
            }
            vim.g.startify_lists = {
                { type = "commands", header = { "    Commands" } },
                { type = "sessions", header = { "    Sessions" } },
                { type = "dir", header = { "    MRU " .. vim.fn.getcwd() } },
            }
        end,
    })
    use({
        "j-hui/fidget.nvim", -- LSP progress indicator
        config = function()
            require("fidget").setup({
                text = {
                    spinner = "dots_scrolling",
                },
            })
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
            require("ag.plugin-conf.catppuccin")
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

    -- Debuggers
    use({
        "mfussenegger/nvim-dap",
        config = function()
            require("ag.plugin-conf.dap")
        end,
    })
    use({
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
            require("ag.plugin-conf.dap")
        end,
    })

    -- Other nice to have
    use({
        "editorconfig/editorconfig-vim", -- .editorconfig support
        config = function()
            vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
        end,
    })
    use({
        "tpope/vim-fugitive", -- git integration
        cmd = { "Git", "Gdiffsplit" },
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
        "jose-elias-alvarez/nvim-lsp-ts-utils", -- helpers for typescript development
        ft = {
            "vue",
            "typescript",
            "javascript",
        },
    })
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
            -- completion sources
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-vsnip",
            -- complements
            "onsails/lspkind-nvim", -- add the nice source + completion item kind to the menu
            "lukas-reineke/cmp-under-comparator", -- better ordering for things with underscores
        },
        config = function()
            require("ag.plugin-conf.completion")
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
                    width = 40,
                    side = "left",
                    auto_resize = true,
                },
                git = {
                    enable = true, -- show git statuses
                    ignore = false, -- still show .gitignored files
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
                manage_folds = false,
                link_folds_to_tree = false,
                link_tree_to_folds = false,
                treesitter = {
                    update_delay = 100,
                },
                filter_kind = {
                    "Class",
                    "Constructor",
                    "Enum",
                    "Function",
                    "Interface",
                    "Method",
                    "Module",
                    "Namespace",
                    "Object",
                    "Package",
                    "Struct",
                },
            })
        end,
    })
end)
-- NOTE: If :h <plugin> does not work, run :helptags ALL to add them
