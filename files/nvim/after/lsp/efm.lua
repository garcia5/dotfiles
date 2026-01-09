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

local initial_should_attach = {}
for language, _ in pairs(languages) do
    initial_should_attach[language] = true
end
vim.g.efm_should_attach = initial_should_attach

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

---Check to see if the current filetype has any linters/formatters that are actually executable
---If not, stop the LSP client
---@param client vim.lsp.Client
---@param bufnr integer
local function efm_attach(client, bufnr)
    local filetype = vim.bo[bufnr].filetype

    local function stop()
        vim.schedule(function() client:stop(true) end)
    end

    local function block_ft()
        local should_attach = vim.g.efm_should_attach
        should_attach[filetype] = false
        vim.g.efm_should_attach = should_attach
        stop()
    end

    -- if we've already checked the linters/formatters for this filetype
    -- and determined none are available, stop the client
    if not vim.g.efm_should_attach[filetype] then stop() end

    local language_config = client.config.settings.languages[filetype]
    if #language_config == 0 then
        block_ft()
        return
    end

    local function get_command(tool)
        local cmd = tool.lintCommand or tool.formatCommand
        if not cmd then return nil end
        return cmd:match("^%S+")
    end

    local function check_executable(cmd, callback)
        vim.schedule(function()
            local is_executable = vim.fn.executable(cmd) == 1
            callback(is_executable)
        end)
    end

    local checked = 0
    local any_executable = false
    local commands = vim.tbl_map(get_command, language_config)

    -- For each linter/formatter for the current filetype, check if the command is executable.
    -- If _no_ linters/formatters are executable, mark this filetype as "false" in the global
    -- `efm_should_attach` dict and stop the client
    for _, cmd in ipairs(commands) do
        check_executable(cmd, function(is_executable)
            checked = checked + 1
            if is_executable then any_executable = true end

            if checked == #commands then
                if not any_executable then
                    block_ft()
                else
                    custom_attach(client, bufnr)
                end
            end
        end)
    end
end

return {
    cmd = { "efm-langserver" },
    filetypes = vim.tbl_keys(languages),
    on_attach = efm_attach,
    settings = {
        rootMarkers = { ".git/" },
        languages = languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics,
    },
}
