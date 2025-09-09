local custom_attach = require("ag.lsp.common").custom_attach
local autopep8 = require("efmls-configs.formatters.autopep8")
local black = require("efmls-configs.formatters.black")
local eslint = require("efmls-configs.linters.eslint_d")
-- local flake8 = require("efmls-configs.linters.flake8")
local prettier = require("efmls-configs.formatters.prettier_d")
local pylint = require("efmls-configs.linters.pylint")
local shellcheck = require("efmls-configs.linters.shellcheck")
local stylua = require("efmls-configs.formatters.stylua")

local languages = {
    lua = { stylua },
    typescript = { prettier, eslint },
    javascript = { prettier, eslint },
    vue = { prettier, eslint },
    -- python = { black, autopep8, flake8, pylint },
    python = { black, autopep8, pylint },
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
        -- flake8 reports everything as error, force it back to hint
        -- (it's never that serious)
        if
            (diagnostic.source == "efm/flake8" or diagnostic.source == "efm/pylint")
            and diagnostic.severity == vim.diagnostic.severity.ERROR
        then
            diagnostic.severity = vim.diagnostic.severity.HINT
        end
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

return vim.tbl_extend("force", efmls_config, {
    cmd = { "efm-langserver" },
    filetypes = vim.tbl_keys(languages),
    on_attach = function(client, bufnr) custom_attach(client, bufnr) end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics,
    },
})
