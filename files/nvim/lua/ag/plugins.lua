local plugin_spec = {
    --[[ Strictly Required ]]
    "nvim-lua/plenary.nvim", -- utility functions

    --[[ Essentials ]]
    "tpope/vim-surround",
    "tpope/vim-repeat",
    -- commenting Just Works
    { "numToStr/Comment.nvim", config = true },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                map_cr = true, -- send closing symbol to its own line
                check_ts = true, -- use treesitter
            })
        end,
        cond = function() return not vim.tbl_contains({ "TelescopePrompt", "fugitive" }, vim.opt.filetype) end,
        event = "InsertEnter",
    },
    -- fuzzy finding
    require("ag.plugin-conf.telescope"),
    -- git integration
    require("ag.plugin-conf.git").gs,
    require("ag.plugin-conf.git").fugitive,
    -- snippets
    require("ag.plugin-conf.luasnip"),
    -- autocomplete
    require("ag.plugin-conf.completion"),

    --[[ Look and Feel ]]
    -- devicons
    {
        "kyazdani42/nvim-web-devicons",
        lazy = true,
    },
    -- extra lsp highlight groups
    "folke/lsp-colors.nvim",
    -- highlight color codes
    {
        "norcalli/nvim-colorizer.lua",
        config = function() require("colorizer").setup(nil, { css = true }) end,
    },
    -- statusline
    require("ag.plugin-conf.lualine"),
    -- startup menu
    require("ag.plugin-conf.alpha"),
    -- highlight window separators
    require("ag.plugin-conf.winsep"),

    --[[ Colorschemes ]]
    require("ag.plugin-conf.catppuccin"),
    require("ag.plugin-conf.tokyonight"),

    --[[ IDE ]]
    require("ag.plugin-conf.lsp"),
    require("ag.plugin-conf.treesitter"),
    require("ag.plugin-conf.dap"),

    --[[ Nice to have ]]
    -- .editorconfig support
    {
        "editorconfig/editorconfig-vim",
        init = function() vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" } end,
    },
    -- convert quotes to template string quotes automatically
    {
        "axelvc/template-string.nvim",
        config = true,
        ft = {
            "typescript",
            "vue",
            "javascript",
            "python",
        },
    },
    -- align text
    { "godlygeek/tabular",     cmd = "Tab" },
    -- file browser
    require("ag.plugin-conf.nvim-tree"),
    -- code outline
    require("ag.plugin-conf.aerial"),
    -- json schema provider
    "b0o/schemastore.nvim",
    -- custom "modes"
    require("ag.plugin-conf.hydra"),
    -- swagger preview
    require("ag.plugin-conf.swagger-preview"),
}

require("lazy").setup(plugin_spec, {
    defaults = {
        lazy = false,
    },
})
