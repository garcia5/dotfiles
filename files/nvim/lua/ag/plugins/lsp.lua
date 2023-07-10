return {
    "neovim/nvim-lspconfig",
    config = function() require("ag.lsp_config") end,
    dependencies = {
        "creativenull/efmls-configs-nvim",
    },
    ft = {
        "vue",
        "typescript",
        "json",
        "javascript",
        "go",
        "rust",
        "lua",
        "python",
        "yaml",
        "bash",
        "zsh",
        "dart",
    },
}
