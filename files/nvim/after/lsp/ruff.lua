local custom_attach = require("ag.lsp.common").custom_attach
local get_venv_path = require("ag.utils").get_python_venv_path

return {
    filetypes = { "python" },
    cmd = { "uvx", "ruff", "server" },
    root_dir = function(bufnr, cb)
        local root = vim.fs.root(bufnr, { "pyproject.toml", "ruff.toml", ".ruff.toml" })
        cb(root)
    end,
    on_attach = function(client, bufnr)
        -- only use ruff as the formatter if it's installed on the current project
        local venv_path = get_venv_path()
        if venv_path == nil or vim.fn.exists(venv_path .. "/bin/ruff") then
            custom_attach(client, bufnr, { allowed_clients = { "efm"} })
        else
            custom_attach(client, bufnr, { allowed_clients = { "ruff" }})
        end
    end,
    init_options = {
        settings = {
            organizeImports = true,
        },
    },
}
