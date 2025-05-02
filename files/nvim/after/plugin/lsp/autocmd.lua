vim.api.nvim_create_autocmd("LspNotify", {
    callback = function(args)
        if args.data.method == "textDocument/didOpen" then vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf)) end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- if LSP client supports it, use LSP for folding instead of TreeSitter
        if client ~= nil and client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
    end,
})
