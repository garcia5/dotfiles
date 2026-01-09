local ty_cmd = require("ag.utils").command_in_virtual_env("ty")
if ty_cmd == nil then return {} end

return {
    filetypes = { "python" },
    cmd = { require("ag.utils").get_python_venv_path() .. "/bin/ty", "server" },
    root_markers = { "pyproject.toml", "Pipfile", "setup.py", ".git" },
    settings = {
        ty = {
            disableLanguageServices = true,
        },
    },
}
