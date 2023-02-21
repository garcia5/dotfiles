return {
    "neovim/nvim-lspconfig",
    config = function() require("ag.lsp_config") end,
    dependencies = {
        "jose-elias-alvarez/null-ls.nvim",
        -- typescript helpers
        {
            "jose-elias-alvarez/nvim-lsp-ts-utils",
            ft = {
                "typescript",
                "vue",
                "javascript",
            },
        },
    },
}
