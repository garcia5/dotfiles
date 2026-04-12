return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    on_attach = function(client, bufnr)
        require("ag.lsp.common").custom_attach(client, bufnr, { format_on_save = true })
        -- auto organize imports
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true,
                })
            end,
        })
    end,
}
