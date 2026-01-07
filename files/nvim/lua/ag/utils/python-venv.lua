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
    -- Default to the active virtual environment
    local active_venv = vim.fn.environ()["VIRTUAL_ENV"]
    if active_venv ~= nil then return active_venv end

    -- Check project-local virtual environment
    local venv = get_venv_path()
    if venv ~= nil then return venv end

    -- Check pipenv
    local pipenv = get_pipenv_venv_path()
    if pipenv ~= nil then return pipenv end

    return nil
end

---Get the python executable path for the current project
---@return string
M.get_python_path = function()
    local venv_path = M.get_python_venv_path()
    if venv_path ~= nil then
        return vim.fs.joinpath(venv_path, "bin", "python")
    else
        return vim.fn.trim(vim.fn.system("python -c 'import sys; print(sys.executable)'"))
    end
end

---Return the full path of the python executable if it exists in the current virtual environment
---If the command does not exist, return nil
---@param exec string command to find in the current virtual environment
---@param venv_only boolean when true, only look in project virtual environment
---@return string | nil
M.command_in_virtual_env = function(exec, venv_only)
    local venv_path = M.get_python_venv_path()
    if venv_only and venv_path == nil then return nil end

    if venv_path ~= nil then
        local exec_path = vim.fs.joinpath(venv_path, "bin", exec)

        if not vim.fn.filereadable(exec_path) then return nil end
        if vim.fn.executable(exec_path) ~= 1 then return nil end

        return exec_path
    -- no virtual environment found, check if installed for system
    else
        if vim.fn.executable(exec) ~= 1 then return nil end
        return exec
    end
end

return M
