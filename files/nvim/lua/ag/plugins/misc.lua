return {
    -- all hail tpope
    "tpope/vim-surround",
    "tpope/vim-repeat",
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
            "python",
        },
    },
    -- align text
    { "godlygeek/tabular", cmd = "Tabularize" },
    -- json schema provider
    "b0o/schemastore.nvim",
}
