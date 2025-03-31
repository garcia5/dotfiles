-- enable built-in autocompletion for LSPs
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.bo.completeopt = "menuone,noselect,fuzzy,popup"
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then return end
        -- automatically trigger autocomplete
        vim.api.nvim_create_autocmd({ "InsertCharPre" }, {
            buffer = args.buf,
            callback = function() vim.lsp.completion.get() end,
        })

        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end,
})
