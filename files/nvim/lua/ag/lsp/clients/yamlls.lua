local custom_attach = require("ag.lsp.common").custom_attach

vim.lsp.config.yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    on_attach = custom_attach,
    settings = {
        yaml = {
            customTags = {
                "!fn",
                "!And",
                "!If",
                "!Not",
                "!Not sequence",
                "!Equals",
                "!Equals sequence",
                "!Or",
                "!FindInMap sequence",
                "!Base64",
                "!Cidr",
                "!Ref",
                "!Sub",
                "!Sub sequence",
                "!GetAtt",
                "!GetAZs",
                "!ImportValue",
                "!Select",
                "!Split",
                "!Join sequence",
                "!GetAtt",
                "!GetAtt sequence",
            },
            schemaStore = {
                enable = false,
            },
        },
    },
}
vim.lsp.enable("yamlls")
