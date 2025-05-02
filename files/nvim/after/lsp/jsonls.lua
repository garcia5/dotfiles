local custom_attach = require("ag.lsp.common").custom_attach

return {
    filetypes = { "json" },
    cmd = { "vscode-json-language-server", "--stdio" },
    on_attach = custom_attach,
}

