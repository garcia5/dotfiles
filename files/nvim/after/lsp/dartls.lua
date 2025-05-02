local custom_attach = require("ag.lsp.common").custom_attach

return {
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { allowed_clients = { "dartls" }, format_on_save = true })
    end,
}
