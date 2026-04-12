return {
    cmd = { "dart", "language-server", "--protocol=lsp" },
    on_attach = function(client, bufnr)
        require("ag.lsp.common").custom_attach(client, bufnr, { format = { format_on_save = true } })
    end,
    filetypes = { "dart" },
}
