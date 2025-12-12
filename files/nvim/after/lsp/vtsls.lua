local custom_attach = require("ag.lsp.common").custom_attach

return {
    cmd = { "vtsls", "--stdio" },
    on_attach = custom_attach,
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
    init_options = {
        hostInfo = "neovim",
    },
    settings = {
        vstls = {
            -- use workspace-installed tsserver if available,
            -- fall back to bundled ts version otherwise
            autoUseWorkspaceTsdk = true,
        },
    },
}
