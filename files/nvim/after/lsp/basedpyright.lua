local custom_attach = require("ag.lsp.common").custom_attach
local has_ty = require("ag.utils").command_in_virtual_env("ty") ~= nil

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
    on_attach = custom_attach,
    settings = {
        basedpyright = {
            autoImportCompletions = true,
            disableOrganizeImports = true,
            analysis = {
                -- if we have `ty` in the current project, use that for type checking instead
                typeCheckingMode = has_ty and "off" or "standard",
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
