return {
    "neovim/nvim-lspconfig",
    config = function() require("ag.lsp_config") end,
    dependencies = {
        "jose-elias-alvarez/null-ls.nvim",
    },
}
