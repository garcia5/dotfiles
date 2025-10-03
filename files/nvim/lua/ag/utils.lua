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

---Return the nearest typescript installation from the given root_dir, or `nil` if
---no installation exists
---@param root_dir string Project cwd
---@return string | nil path server path to use, or nil if no typescript installation is found
M.get_typescript_server_path = function(root_dir)
    local check_path = function(dir)
        local install_path = vim.fs.joinpath(dir, "node_modules", "typescript", "lib")
        if vim.fn.isdirectory(install_path) == 1 then return install_path end
        return nil
    end

    -- check current dir for typescript
    local project_ts_path = check_path(root_dir)
    if project_ts_path ~= nil then return project_ts_path end

    -- check parent directories for typescript in case of monorepo setup
    for dir in vim.fs.parents(root_dir) do
        project_ts_path = check_path(dir)
        if project_ts_path ~= nil then return project_ts_path end
    end

    -- fallback to global install
    local default_node_version = vim.fn.trim(vim.fn.system("nvm current"))
    local global_ts =
        vim.fn.expand("$NVM_DIR/versions/node/" .. default_node_version .. "/lib/node_modules/typescript/lib")
    if vim.fn.isdirectory(global_ts) == 1 then return global_ts end
    return nil
end

return M
