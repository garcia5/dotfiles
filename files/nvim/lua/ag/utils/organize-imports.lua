local M = {}

---Register the <Leader>ii keymap to run organize imports for the given language server
---@param client_name string name of the LSP client that should organize imports
---@param bufnr integer the buffer to apply edits to
---@param mapping string | nil the keymap to use to organize imports (default <Leader>ii)
M.register_organize_imports = function(client_name, bufnr, mapping)
    vim.keymap.set(
        "n",
        mapping or "<Leader>ii",
        function()
            vim.lsp.buf.code_action({
                context = {
                    diagnostics = vim.diagnostic.get(bufnr),
                    only = {
                        "source.organizeImports",
                    },
                },
                apply = true,
            })
        end,
        { buffer = bufnr, desc = client_name .. ": Organize Imports", silent = true, noremap = true }
    )
end

return M
