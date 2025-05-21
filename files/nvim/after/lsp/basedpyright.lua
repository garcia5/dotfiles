local custom_attach = require("ag.lsp.common").custom_attach

local ruff_organize_imports = function(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local ruff_cmd = "ruff"
    local python_venv_path = require("ag.utils").get_python_venv_path()
    if python_venv_path ~= nil then
        ruff_cmd = python_venv_path .. "/bin/ruff"
    end
    local cmd = { ruff_cmd, "check" , "--select", "I", "--fix", "--", fname }
    vim.system(cmd)
end

return {
    filetypes = { "python" },
    cmd = { "basedpyright-langserver", "--stdio" },
    root_dir = function(bufnr, cb)
        local root = vim.fs.root(
            bufnr,
            { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json" }
        )
        cb(root)
    end,
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        vim.keymap.set(
            "n",
            "<Leader>ii",
            function() ruff_organize_imports(bufnr) end,
            { buffer = bufnr, silent = true, desc = "LSP Organize Imports" }
        )
    end,
    settings = {
        basedpyright = {
            autoImportCompletions = true,
            disableOrganizeImports = true,
            analysis = {
                typeCheckingMode = "standard",
                inlayHints = {
                    genericTypes = false,
                    callArgumentNames = false,
                },
            },
        },
        python = {
            pythonPath = require("ag.utils").get_python_path(),
        },
    },
}
