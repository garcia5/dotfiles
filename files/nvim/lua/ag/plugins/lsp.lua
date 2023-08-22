local lsp_config = {
    "neovim/nvim-lspconfig",
    config = function() require("ag.lsp_config") end,
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

local efm = {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x",
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
        local custom_attach = require("ag.lsp_config").custom_attach
        local lspconfig = require("lspconfig")

        local eslint = require("efmls-configs.linters.eslint_d")
        local prettier = require("efmls-configs.formatters.prettier_d")
        local stylua = require("efmls-configs.formatters.stylua")
        local black = require("efmls-configs.formatters.black")
        local languages = {
            lua = { stylua },
            typescript = { prettier, eslint },
            javascript = { prettier, eslint },
            vue = { prettier, eslint },
            python = { black },
        }
        local efmls_config = {
            filetypes = vim.tbl_keys(languages),
            settings = {
                rootMarkers = { ".git/" },
                languages = languages,
            },
            init_options = {
                documentFormatting = true,
                documentRangeFormatting = true,
            },
        }

        lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
            on_attach = function(client, bufnr) custom_attach(client, bufnr, { allowed_clients = { "efm" } }) end,
        }))
    end,
    ft = {
        "lua",
        "typescript",
        "javascript",
        "vue",
        "python",
    },
}

return {
    lsp_config,
    efm,
}
