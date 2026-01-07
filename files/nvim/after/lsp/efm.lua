vim.g.efm_should_attach = true

local custom_attach = require("ag.lsp.common").custom_attach
local autopep8 = require("efmls-configs.formatters.autopep8")
local black = require("efmls-configs.formatters.black")
local eslint = require("efmls-configs.linters.eslint_d")
local flake8 = require("efmls-configs.linters.flake8")
local prettier = require("efmls-configs.formatters.prettier_d")
local pylint = require("efmls-configs.linters.pylint")
local shellcheck = require("efmls-configs.linters.shellcheck")
local stylua = require("efmls-configs.formatters.stylua")

local languages = {
    lua = { stylua },
    typescript = { prettier, eslint },
    javascript = { prettier, eslint },
    typescriptreact = { prettier, eslint },
    javascriptreact = { prettier, eslint },
    vue = { prettier, eslint },
    python = { black, autopep8, flake8, pylint },
    bash = { shellcheck },
    sh = { shellcheck },
}

-- special handling for python to use virtual envs w/o activating
local python_venv_path = require("ag.utils").get_python_venv_path()
if python_venv_path ~= nil then
    local cmd_prefix = python_venv_path .. "/bin/"
    for _, prog in ipairs(languages["python"]) do
        local cmd = prog["formatCommand"]
        if cmd == nil then cmd = prog["lintCommand"] end

        -- only prepend virtual env if it's not already there
        if cmd ~= nil and cmd:find(cmd_prefix, 1, true) == nil then
            if prog["formatCommand"] then prog["formatCommand"] = cmd_prefix .. cmd end
            if prog["lintCommand"] then prog["lintCommand"] = cmd_prefix .. cmd end
        end
    end
end

-- explicitly point stylua to my config
local stylua_format_cmd = languages["lua"][1]["formatCommand"]
if not stylua_format_cmd:match(".*config%-path.*") then
    local new_cmd = stylua_format_cmd:gsub("(stylua)", "%1 --config-path .stylua.toml")
    languages["lua"][1]["formatCommand"] = new_cmd
end

---custom handler to clean up linter diagnostics
local custom_publish_diagnostics = function(_, result, ctx, _)
    -- filter out duplicitive diagnostics from flake8 that pyright
    -- already covers
    local flake8_ignore_codes = {
        "841", -- F841: unused variable
        "401", -- F401: unused import
    }
    result.diagnostics = vim.tbl_filter(function(diagnostic)
        if diagnostic.source ~= "efm/flake8" then return true end
        return not vim.list_contains(flake8_ignore_codes, diagnostic.code)
    end, result.diagnostics)

    for _, diagnostic in pairs(result.diagnostics) do
        -- drop all linter diagnostics down to HINT severity rather than ERROR
        -- (it's never that serious)
        diagnostic.severity = vim.diagnostic.severity.HINT
        -- remove built in "[source]" from diagnostic prefix
        -- displaying the source is taken care of my global diagnostic config
        if diagnostic.message then diagnostic.message = string.gsub(diagnostic.message, "^%[[^%s]+%] ", "") end
    end
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
end

local efmls_config = {
    filetypes = vim.tbl_keys(languages),
    settings = {
        rootMarkers = { ".git/" },
        languages = languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}

---Check to see if the current filetype has any linters/formatters that are actually executable
---If not, stop the LSP client
---@param client vim.lsp.Client
---@param bufnr integer
local function check_tools_exist(client, bufnr)
    if not vim.g.efm_should_attach then return end

    local filetype = vim.bo[bufnr].filetype
    local language_config = client.config.settings.languages[filetype]
    if #language_config == 0 then
        vim.g.efm_should_attach = false
        return
    end

    local function get_command(tool) return tool.lintCommand or tool.formatCommand end

    local function check_executable(cmd, callback)
        vim.schedule(function()
            local is_executable = vim.fn.executable(cmd) == 1
            callback(is_executable)
        end)
    end

    local any_executable = false
    local commands = vim.tbl_map(get_command, language_config)

    for _, cmd in ipairs(commands) do
        check_executable(cmd, function(is_executable)
            if is_executable then any_executable = true end
        end)
    end
    if not any_executable then vim.g.efm_should_attach = false end
end

return vim.tbl_extend("force", efmls_config, {
    cmd = { "efm-langserver" },
    filetypes = vim.tbl_keys(languages),
    ---@param client vim.lsp.Client
    ---@param bufnr integer
    on_attach = function(client, bufnr)
        check_tools_exist(client, bufnr)
        if not vim.g.efm_should_attach then client:stop(true) end
        custom_attach(client, bufnr)
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics,
    },
})
