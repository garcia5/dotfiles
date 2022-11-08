-- Bootstrap packer if necessary
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
local lsp_filetypes = require("ag.lsp_config").lsp_filetypes

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Init setup
vim.cmd("packadd packer.nvim") -- load packer
local packer = require("packer")

packer.init({
    auto_reload_compiled = true,
})

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
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    })
    use({
        "windwp/nvim-ts-autotag", -- auto close html tags
        ft = {
            "html",
            "vue",
        },
    })
    use({
        "windwp/nvim-autopairs", -- auto close sybmols
        config = function()
            require("nvim-autopairs").setup({
                map_cr = true, -- send closing symbol to its own line
                check_ts = true, -- use treesitter
            })
        end,
        disable_filetype = { "TelescopePrompt", "fugitive" },
    })
    use("tpope/vim-surround") -- surround
    use("tpope/vim-repeat") -- ... and make them repeatable
    use({
        "nvim-telescope/telescope.nvim", -- fuzzy find ALL the things
        config = function() require("ag.plugin-conf.telescope") end,
    })

    -- Look and feel
    use({
        "folke/lsp-colors.nvim", -- LSP colors that aren't built in
        ft = lsp_filetypes,
    })
    use({
        "norcalli/nvim-colorizer.lua", -- enable textDocument/documentColor
        config = function() require("colorizer").setup() end,
    })
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
                preview_config = {
                    border = "solid",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
                signcolumn = true,
                numhl = true,
                update_debounce = 500,
                attach_to_untracked = true,
                on_attach = function(bufnr)
                    local keymap_opts = { silent = true, noremap = true, buffer = bufnr }
                    vim.keymap.set("n", "=", "<cmd>Gitsigns preview_hunk<CR>", keymap_opts)
                    vim.keymap.set("n", "<Leader>rh", "<cmd>Gitsigns reset_hunk<CR>", keymap_opts)
                    vim.keymap.set("n", "<Leader>sh", "<cmd>Gitsigns stage_hunk<CR>", keymap_opts)
                    vim.keymap.set("n", "<Leader>gn", "<cmd>Gitsigns next_hunk<CR>", keymap_opts)
                    vim.keymap.set("n", "<Leader>gp", "<cmd>Gitsigns prev_hunk<CR>", keymap_opts)
                    vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { default = true, link = "GitSignsDelete" })
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
        config = function() require("ag.plugin-conf.lualine") end,
    })
    use("p00f/nvim-ts-rainbow") -- rainbow braces (and tags) powered by treesitter
    use({
        "mhinz/vim-startify", -- start menu
        config = function()
            -- don't change directory when I select a file
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 0
            vim.g.startify_commands = {
                { f = { "Find Files", "Telescope find_files" } },
                { g = { "Live Grep", "Telescope live_grep" } },
                { c = { "Checkout Branch", "Telescope git_branches" } },
            }
            vim.g.startify_files_number = 5 -- show 5 most recent files
            vim.g.startify_lists = {
                { type = "commands", header = { "    Commands" } }, -- Commands from above
                { type = "dir", header = { "    MRU " .. vim.fn.getcwd() } }, -- MRU files from CWD
            }
        end,
    })
    use({
        "nvim-telescope/telescope-ui-select.nvim", -- Use telescope to override vim.ui.select
        requires = { "nvim-telescope/telescope.nvim" },
    })
    use({
        "nvim-zh/colorful-winsep.nvim", -- clearer window separators
        config = function()
            local winsep = require("colorful-winsep")
            winsep.setup({
                highlight = {
                    guibg = vim.api.nvim_get_hl_by_name("Normal", true)["background"],
                    guifg = "#c099ff",
                },
                interval = 50,
                no_exec_files = { "packer", "TelescopePrompt" },
                -- disable if I only have 2 files open
                create_event = function()
                    local win_handles = vim.api.nvim_list_wins()
                    local num_visible = 0
                    for _, handle in ipairs(win_handles) do
                        local win_config = vim.api.nvim_win_get_config(handle)
                        if win_config["focusable"] then num_visible = num_visible + 1 end
                    end
                    if num_visible < 3 then winsep.NvimSeparatorDel() end
                end,
            })
        end,
    })

    -- Colorschemes
    use({
        "catppuccin/nvim", -- the lua colorscheme
        as = "catppuccin",
        config = function() require("ag.plugin-conf.catppuccin") end,
        run = ":CatppuccinCompile",
    })
    use({
        "folke/tokyonight.nvim",
        config = function() require("ag.plugin-conf.tokyonight") end,
    })
    use({
        "lukas-reineke/indent-blankline.nvim", -- indent guides
        config = function()
            vim.g.indent_blankline_filetype_exclude = {
                "lspinfo",
                "packer",
                "checkhealth",
                "help",
                "startify",
            }
            vim.g.indent_blankline_use_treesitter = true
            vim.g.indent_blankline_disable_with_nolist = true
        end,
        disable = true,
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
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function() require("ag.plugin-conf.dap") end,
    })
    use({
        "nvim-telescope/telescope-dap.nvim", -- telescope picker for dap actions/configuraitons
        requires = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
    })

    -- Other nice to have
    use({
        "editorconfig/editorconfig-vim", -- .editorconfig support
        config = function() vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" } end,
    })
    use({
        "tpope/vim-fugitive", -- git integration
        cmd = { "Git", "Gdiffsplit" },
    })
    use("JoosepAlviste/nvim-ts-context-commentstring") -- commenting in vue files "just works"
    use({
        "jose-elias-alvarez/nvim-lsp-ts-utils", -- helpers for typescript development
        ft = {
            "typescript",
            "vue",
            "javascript",
        },
    })
    use({
        "axelvc/template-string.nvim", -- automatically turn quotes into backticks if I type a template placeholder
        ft = {
            "typescript",
            "vue",
            "javascript",
        },
        config = function()
            require("template-string").setup({
                filetypes = { "typescript", "vue", "javascript" },
            })
        end,
    })
    use({
        "hrsh7th/vim-vsnip", -- snippets
        config = function()
            vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snips")
            vim.keymap.set({ "i", "s" }, "<C-j>", function()
                if vim.fn["vsnip#jumpable"](1) then
                    return "<Plug>(vsnip-jump-next)"
                else
                    return "<C-j>"
                end
            end, { silent = true, expr = true })
            vim.keymap.set({ "i", "s" }, "<C-k>", function()
                if vim.fn["vsnip#jumpable"](-1) then
                    return "<Plug>(vsnip-jump-prev)"
                else
                    return "<C-k>"
                end
            end, { silent = true, expr = true })
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
            "hrsh7th/cmp-path",
            -- complements
            "onsails/lspkind-nvim", -- add the nice source + completion item kind to the menu
        },
        config = function() require("ag.plugin-conf.completion") end,
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
                hijack_cursor = true,
                view = {
                    adaptive_size = true,
                    width = 30,
                    side = "left",
                },
                git = {
                    enable = true, -- show git statuses
                    ignore = false, -- still show .gitignored files
                },
            })
        end,
        cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeRefresh" },
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
                layout = {
                    max_width = 40,
                    min_width = 20,
                },
                close_automatic_events = { "switch_buffer" },
                manage_folds = false,
                link_folds_to_tree = false,
                link_tree_to_folds = true,
                treesitter = {
                    update_delay = 100,
                },
            })
        end,
    })
    use("b0o/schemastore.nvim") -- json schema provider
    use({
        "anuvyklack/hydra.nvim", -- custom "modes"
        config = function() require("ag.plugin-conf.hydra") end,
    })

    -- Grab all packages if we're setting up for the first time
    if packer_bootstrap then packer.sync() end
end)
-- NOTE: If :h <plugin> does not work, run :helptags ALL to add them

return packer_bootstrap
