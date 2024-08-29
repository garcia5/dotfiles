local M = {}

---Get the path to the current pipenv managed virtual environment (if one exists)
---@return string | nil
M.get_pipenv_venv_path = function()
    local lspconfig = require("lspconfig")
    local pipenv_venv = vim.fn.trim(vim.fn.system("pipenv --venv"))
    local split = vim.split(pipenv_venv, "\n")
    for _, line in ipairs(split) do
        if string.match(line, "^/") ~= nil then
            if lspconfig.util.path.exists(line) then return line end
        end
    end

    return nil
end

return M
