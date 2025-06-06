local custom_attach = require("ag.lsp.common").custom_attach

return {
    filetypes = { "python" },
    cmd = { "uvx", "ruff", "server" },
    root_dir = function(bufnr, cb)
        local root = vim.fs.root(bufnr, { "pyproject.toml", "ruff.toml", ".ruff.toml" })
        cb(root)
    end,
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)
    end,
    init_options = {
        settings = {
            organizeImports = true,
        },
    },
}
