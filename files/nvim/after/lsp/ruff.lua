local custom_attach = require("ag.lsp.common").custom_attach

return {
    filetypes = { "python" },
    cmd = { "uvx", "ruff", "server" },
    root_dir = function(bufnr, cb)
        local is_diffview = vim.fn.bufname(bufnr):match("^diffview%S")
        if not is_diffview then
            local root = vim.fs.root(bufnr, { "pyproject.toml", "ruff.toml", ".ruff.toml" })
            cb(root)
        end
    end,
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)
        -- organize imports keymap
        vim.keymap.set(
            "n",
            "<Leader>ii",
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
            { buffer = true, desc = "Ruff organize imports", silent = true, noremap = true }
        )
    end,
    init_options = {
        settings = {
            organizeImports = true,
        },
    },
}
