local custom_attach = require("ag.lsp.common").custom_attach
local has_ty = require("ag.utils").command_in_virtual_env("ty", true) ~= nil

return {
    filetypes = { "python" },
    cmd = { "basedpyright-langserver", "--stdio" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json" },
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, {
            references = {
                test_file_filter = function(fname) return fname:match("^test_") end,
                inclue_declaration = false,
            },
        })
    end,
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
