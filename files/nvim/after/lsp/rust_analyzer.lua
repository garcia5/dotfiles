local custom_attach = require("ag.lsp.common").custom_attach

return {
    filetypes = { "rust" },
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { format_on_save = true, allowed_clients = { "rust_analyzer" } })
    end,
}
