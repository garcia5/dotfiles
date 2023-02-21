local lsp_filetypes = require("ag.lsp_config").lsp_filetypes
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    --#region Strictly Required
    "nvim-lua/plenary.nvim", -- utility functions
    --#endregion

    --#region Essentials
    "tpope/vim-surround",
    "tpope/vim-repeat",
    -- commenting Just Works
    {
        "numToStr/Comment.nvim",
        config = true,
    },
    -- auto close HTML tags
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "vue",
        },
    },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                map_cr = true, -- send closing symbol to its own line
                check_ts = true, -- use treesitter
            })
        end,
        disable_filetype = { "TelescopePrompt", "fugitive" },
    },
    -- fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        config = function() require("ag.plugin-conf.telescope") end,
        keys = {
            {
                "<Leader>ff",
                "<cmd>Telescope find_files<CR>",
                desc = "Find files",
            },
            {
                "<Leader>fb",
                "<cmd>Telescope buffers<CR>",
                desc = "Switch buffer",
            },
            {
                "<Leader>fl",
                "<cmd>Telescope current_buffer_fuzzy_find<CR>",
                desc = "Find in file",
            },
            {
                "<Leader>gg",
                "<cmd>Telescope live_grep<CR>",
                desc = "Grep",
            },
            {
                "<Leader>fr",
                "<cmd>Telescope lsp_references<CR>",
                desc = "Find references",
            },
            {
                "<Leader>co",
                "<cmd>Telescope colorscheme<CR>",
                desc = "Switch colorscheme",
            },
            {
                "<Leader>gc",
                "<cmd>Telescope git_branches<CR>",
                desc = "Checkout branches",
            },
            {
                "<Leader>re",
                "<cmd>Telescope git_commits<CR>",
                desc = "Checkout commits",
            },
            {
                "<Leader>qf",
                function() require("telescope.builtin").quickfilx(require("telescope.themes").get_ivy()) end,
                desc = "Jump to items in quickfix list",
            },
        },
    },
    -- git integration
    {
        "tpope/vim-fugitive",
        lazy = true,
        keys = {
            {
                "<Leader>gs",
                ":tab Git<CR>",
                desc = "Git status in new tab",
            },
            {
                "<Leader>gd",
                "<cmd>Gdiffsplit<CR>",
                desc = "diff file in split",
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        opts = {
            preview_config = {
                border = "solid",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            signcolumn = true,
            numhl = true,
            on_attach = function(bufnr)
                local keymap_opts = { silent = true, noremap = true, buffer = bufnr }
                vim.keymap.set(
                    "n",
                    "=",
                    "<cmd>Gitsigns preview_hunk<CR>",
                    vim.tbl_extend(keymap_opts, { desc = "Gitsigns float preview" })
                )
                vim.keymap.set(
                    "n",
                    "<Leader>rh",
                    "<cmd>Gitsigns reset_hunk<CR>",
                    vim.tbl_extend(keymap_opts, { desc = "Gitsigns float preview" })
                )
                vim.keymap.set(
                    "n",
                    "<Leader>sh",
                    "<cmd>Gitsigns stage_hunk<CR>",
                    vim.tbl_extend(keymap_opts, { desc = "Gitsigns stage" })
                )
                vim.keymap.set(
                    "n",
                    "<Leader>gn",
                    "<cmd>Gitsigns next_hunk<CR>",
                    vim.tbl_extend(keymap_opts, { desc = "Gitsigns goto next" })
                )
                vim.keymap.set(
                    "n",
                    "<Leader>gp",
                    "<cmd>Gitsigns prev_hunk<CR>",
                    vim.tbl_extend(keymap_opts, { desc = "Gitsigns goto prev" })
                )
            end,
        },
    },
    -- snippets
    {
        "L3MON4D3/LuaSnip", -- snippets
        name = "luasnip",
        lazy = true,
        tag = "v1.*",
        config = function() require("ag.plugin-conf.luasnip") end,
    },
    -- autocomplete
    {
        "hrsh7th/nvim-cmp", -- autocomplete
        lazy = true,
        requires = {
            -- completion sources
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",
            -- complements
            "onsails/lspkind-nvim", -- add the nice source + completion item kind to the menu
        },
        config = function() require("ag.plugin-conf.completion") end,
    },
    --#endregion

    --#region Look and Feel
    -- devicons
    "kyazdani42/nvim-web-devicons",
    -- extra lsp highlight groups
    "folke/lsp-colors.nvim",
    -- highlight color codes
    {
        "norcalli/nvim-colorizer.lua",
        lazy = true,
        config = function()
            require("colorizer").setup({
                "css",
                "scss",
                "vue",
                "html",
                "tmTheme",
                "kitty",
            })
        end,
    },
    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
        config = function() require("ag.plugin-conf.lualine") end,
    },
    -- rainbow braces
    {
        "mrjones2014/nvim-ts-rainbow",
        lazy = true,
    },
    -- startup menu
    {
        "goolord/alpha-nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
        config = function() require("ag.plugin-conf.alpha") end,
    },
    -- override vim.ui.select with telescope
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    -- highlight window separators
    {
        "nvim-zh/colorful-winsep.nvim",
        commit = "9a474934a27203d1c2e9943c94a29165dd81823d",
        lazy = true,
        opts = {
            highlight = {
                guibg = vim.api.nvim_get_hl_by_name("Normal", true)["background"],
                guifg = "#c099ff",
            },
            interval = 50,
            no_exec_files = { "packer", "TelescopePrompt" },
            -- disable if I only have 2 files open
            create_event = function()
                local winsep = require("colorful-winsep")
                local win_handles = vim.api.nvim_list_wins()
                local num_visible = 0
                for _, handle in ipairs(win_handles) do
                    local win_config = vim.api.nvim_win_get_config(handle)
                    if win_config["focusable"] then num_visible = num_visible + 1 end
                end
                if num_visible < 3 then winsep.NvimSeparatorDel() end
            end,
        },
    },
    --#endregion

    --#region Colorschemes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function() require("ag.plugin-conf.catppuccin") end,
        run = ":CatppuccinCompile",
        enabled = false,
    },
    {
        "folke/tokyonight.nvim", -- the other lua colorscheme
        lazy = false,
        priority = 1000,
        config = function() require("ag.plugin-conf.tokyonight") end,
    },
    --#endregion

    --#region LSP, treesitter
    -- use builtin LSP
    "neovim/nvim-lspconfig",
    -- wrapper for linters, formatters
    "jose-elias-alvarez/null-ls.nvim",
    -- treesitter
    {
        "nvim-treesitter",
        build = ":TSUpdate",
    },
    -- extra treesitter features
    "nvim-treesitter/nvim-treesitter-textobjects",
    --#endregion

    --#region Debuggers
    -- debug adapter + UI
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function() require("ag.plugin-conf.dap") end,
    },
    -- telescope picker for debugging
    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
    },
    --#endregion

    --#region Nice to have
    -- .editorconfig support
    {
        "editorconfig/editorconfig-vim",
        lazy = false,
        init = function() vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" } end,
    },
    -- comment in vue files
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        ft = { "vue" },
    },
    -- typescript helpers
    {
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        ft = {
            "typescript",
            "vue",
            "javascript",
        },
    },
    -- convert quotes to template string quotes automatically
    {
        "axelvc/template-string.nvim",
        ft = {
            "typescript",
            "vue",
            "javascript",
            "python",
        },
        config = true,
    },
    -- align text
    {
        "godlygeek/tabular",
        cmd = "Tab",
    },
    {
        "kyazdani42/nvim-tree.lua", -- no more netrw
        opts = {
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
        },
        keys = {
            { "<Leader>nt", "<cmd>NvimTreeToggle<CR>",   desc = "toggle file browser" },
            { "<Leader>nf", "<cmd>NvimTreeFindFile<CR>", desc = "open file browser with current file showing" },
            { "<Leader>nr", "<cmd>NvimTreeRefresh<CR>",  desc = "refresh file browser" },
        },
    },
    -- use fzf searching for telescope
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    },
    -- code outline
    {
        "stevearc/aerial.nvim",
        opts = {
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
        },
        keys = {
            { "<Leader>ou", "<cmd>AerialToggle!<CR>", desc = "toggle code outline" },
        },
    },
    -- json schema provider
    "b0o/schemastore.nvim",
    -- custom "modes"
    {
        "anuvyklack/hydra.nvim", -- custom "modes"
        config = function() require("ag.plugin-conf.hydra") end,
    },
    -- swagger preview
    {
        "vinnymeller/swagger-preview.nvim",
        build = "npm install -g swagger-ui-watcher",
        opts = {
            port = 8000,
            host = "localhost",
        },
        cmd = { "SwaggerPreview", "SwaggerPreviewToggle" },
    },
})
