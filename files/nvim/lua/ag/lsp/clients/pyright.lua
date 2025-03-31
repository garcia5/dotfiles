local custom_attach = require("ag.lsp.common").custom_attach

local pyright_organize_imports = function(client)
    local params = {
        command = "pyright.organizeimports",
        arguments = { vim.uri_from_bufnr(0) },
    }

    client:request("workspace/executeCommand", params, nil, 0)
end

vim.lsp.config.pyright = {
    filetypes = { "python" },
    cmd = { "pyright-langserver", "--stdio" },
    -- manually set root_dir to avoid it getting overriden by the `pythonPath` setting
    root_dir = function(bufnr, cb)
        local root = vim.fs.root(bufnr, { "pyproject.toml", "requirements.txt", "Pipfile" })
        cb(root)
    end,
    -- automatically set the language server's python path to the project's virtual environment,
    -- even if it's not explicitly active when I start nvim
    before_init = function(_, config)
        local python_path = require("ag.utils").get_python_path()
        if python_path ~= nil then config.settings.python = { pythonPath = python_path } end
    end,
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { allowed_clients = { "efm" } })
        vim.keymap.set("n", "<Leader>ii", pyright_organize_imports, {
            buffer = bufnr,
            silent = true,
            noremap = true,
        })
    end,
    settings = {
        pyright = {
            disableOrganizeImports = false,
            analysis = {
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
            },
        },
    },
}
