local M = {}

---Get the path to the current pipenv managed virtual environment (if one exists)
---@return string | nil
local get_pipenv_venv_path = function()
    local pipenv_venv = vim.fn.trim(vim.fn.system("pipenv --venv"))
    if pipenv_venv == "" then return nil end
    local split = vim.split(pipenv_venv, "\n")
    for _, line in ipairs(split) do
        if string.match(line, "^/") ~= nil then
            if vim.fn.isdirectory(line) then return line end
        end
    end

    return nil
end

local get_venv_path = function()
    if vim.fn.isdirectory(".venv") ~= 0 then return ".venv" end
    return nil
end

---Get the path to the virtual environment for the current project
---@return string | nil
M.get_python_venv_path = function()
    local venv = get_venv_path()
    if venv ~= nil then return venv end
    local pipenv = get_pipenv_venv_path()
    if pipenv ~= nil then return pipenv end

    return nil
end

---Get the python executable path for the current project
---@return string
M.get_python_path = function()
    local venv_path = M.get_python_venv_path()
    if venv_path ~= nil then
        return venv_path .. "/bin/python"
    else
        return vim.fn.trim(vim.fn.system("python -c 'import sys; print(sys.executable)'"))
    end
end

-- Use project-local typescript installation if available, fallback to global install
-- assumes typescript installed globally w/ nvm
M.get_typescript_server_path = function(root_dir)
    local lspconfig = require("lspconfig")
    local global_ts = vim.fn.expand("$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION/lib/node_modules/typescript/lib")
    local project_ts = ""
    local function check_dir(path)
        project_ts = lspconfig.util.path.join(path, "node_modules", "typescript", "lib")
        if vim.fn.isdirectory(project_ts) then return path end
    end
    if lspconfig.util.search_ancestors(root_dir, check_dir) then
        return project_ts
    else
        return global_ts
    end
end

return M
