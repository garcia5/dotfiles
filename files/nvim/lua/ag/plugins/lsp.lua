return {
    "neovim/nvim-lspconfig",
    config = function() require("ag.lsp_config") end,
    dependencies = {
        {
            "creativenull/efmls-configs-nvim",
            config = function()
                local custom_attach = require("ag.lsp_config").custom_attach
                local efmls = require("efmls-configs")
                efmls.init({
                    on_attach = function(client, bufnr) custom_attach(client, bufnr, { "efm" }) end,
                    init_options = {
                        documentFormatting = true,
                        codeAction = true,
                    },
                })
                local eslint = require("efmls-configs.linters.eslint")
                local prettier = require("efmls-configs.formatters.prettier")
                local stylua = require("efmls-configs.formatters.stylua")
                local black = require("efmls-configs.formatters.black")
                efmls.setup({
                    lua = {
                        formatter = stylua,
                    },
                    typescript = {
                        formatter = prettier,
                        linter = eslint,
                    },
                    javascript = {
                        formatter = prettier,
                        linter = eslint,
                    },
                    vue = {
                        formatter = prettier,
                        linter = eslint,
                    },
                    python = {
                        formatter = black,
                    },
                })
            end,
        },
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
