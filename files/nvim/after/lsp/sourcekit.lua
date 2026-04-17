return {
    cmd = { "sourcekit-lsp" },
    filetypes = { "swift" },
    root_markers = {
        ".git",
        "compile_commands.json",
        ".sourcekit-lsp",
        "Package.swift",
    },
    on_attach = function(client, bufnr)
        require("ag.lsp.common").custom_attach(client, bufnr, { format = { format_on_save = true } })
    end,
    get_language_id = function(_, ftype) return ftype end,
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
        textDocument = {
            diagnostic = {
                dynamicRegistration = true,
                relatedDocumentSupport = true,
            },
        },
    },
}
