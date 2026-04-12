return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    on_attach = function(client, bufnr)
        require("ag.lsp.common").custom_attach(client, bufnr, { format_on_save = true })
    end,
}
