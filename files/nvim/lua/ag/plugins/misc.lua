return {
    -- utility functions
    "nvim-lua/plenary.nvim",

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
    -- devicons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    -- highlight color codes
    {
        "norcalli/nvim-colorizer.lua",
        config = function() require("colorizer").setup(nil, { css = true }) end,
    },
    -- convert quotes to template string quotes automatically
    {
        "axelvc/template-string.nvim",
        config = true,
        ft = {
            "typescript",
            "vue",
            "javascript",
        },
    },
    -- align text
    { "godlygeek/tabular", cmd = "Tab" },
    -- json schema provider
    "b0o/schemastore.nvim",
}
