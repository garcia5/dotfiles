local custom_attach = require("ag.lsp.common").custom_attach

return {
    cmd = { "bash-language-server", "start" },
    on_attach = custom_attach,
    filetypes = { "bash", "sh", "zsh" },
}
