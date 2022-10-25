local lspconfig = require("lspconfig")

local lsp_filetypes = {
    "vue",
    "typescript",
    "json",
    "javascript",
    "python",
    "rust",
    "yaml",
    "bash",
    "lua",
}

-- Give floating windows borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

-- Configure diagnostic display
vim.diagnostic.config({
    virtual_text = {
        -- Only display errors w/ virtual text
        severity = vim.diagnostic.severity.ERROR,
        -- Prepend with diagnostic source if there is more than one attached to the buffer
        -- (e.g. (eslint) Error: blah blah blah)
        source = "if_many",
        signs = false,
    },
    float = {
        severity_sort = true,
        source = "if_many",
        border = "solid",
        header = {
            "",
            "LspDiagnosticsDefaultWarning",
        },
        prefix = function(diagnostic)
            local diag_to_format = {
                [vim.diagnostic.severity.ERROR] = { "Error", "LspDiagnosticsDefaultError" },
                [vim.diagnostic.severity.WARN] = { "Warning", "LspDiagnosticsDefaultWarning" },
                [vim.diagnostic.severity.INFO] = { "Info", "LspDiagnosticsDefaultInfo" },
                [vim.diagnostic.severity.HINT] = { "Hint", "LspDiagnosticsDefaultHint" },
            }
            local res = diag_to_format[diagnostic.severity]
            return string.format("(%s) ", res[1]), res[2]
        end,
    },
    severity_sort = true,
})

local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
-- Don't let tsserver or vuels do formatting, they do it wrong
local custom_format = function(bufnr)
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client) return client.name ~= "tsserver" and client.name ~= "vuels" end,
    })
end

local custom_attach = function(client, bufnr)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    -- LSP mappings (only apply when LSP client attached)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, keymap_opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, keymap_opts)

    -- diagnostics
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.open_float, keymap_opts) -- diagnostic(s) on current line
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, keymap_opts) -- move to next diagnostic in buffer
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, keymap_opts) -- move to prev diagnostic in buffer
    vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, keymap_opts) -- show all buffer diagnostics in qflist
    vim.keymap.set("n", "H", vim.lsp.buf.code_action, keymap_opts) -- code actions (handled by telescope-ui-select)
    vim.keymap.set("n", "<leader>F", function() custom_format(bufnr) end, keymap_opts) -- manual formatting, because sometimes null-ls just decides to stop working

    -- use omnifunc
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"

    -- format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function() custom_format(bufnr) end,
    })
end

local web_dev_attach = function(client, bufnr)
    local root_files = vim.fn.readdir(vim.fn.getcwd())
    local volar = false
    -- TODO: the "right" way to do this would be to check the typescript version, but that seems hard
    for _, fname in ipairs(root_files) do
        if fname == "pnpm-lock.yaml" then volar = true end
    end

    -- disable vuels and tsserver if we're using volar
    if volar and (client.name == "tsserver" or client.name == "vuels") then
        client.stop()
        return false
    end

    -- disable volar if we don't have pnpm
    if not volar and client.name == "volar" then
        client.stop()
        return false
    end

    custom_attach(client, bufnr)
    return true
end

-- Set up clients
local null_ls = require("null-ls")
null_ls.setup({
    on_attach = custom_attach,
    sources = {
        --#formatters
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.eslint_d,

        --#diagnostics/linters
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.eslint_d,

        --#code actions
        null_ls.builtins.code_actions.eslint_d,
    },
})

-- python
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)
        -- 'Organize imports' keymap for pyright only
        vim.keymap.set("n", "<Leader>ii", "<cmd>PyrightOrganizeImports<CR>", {
            buffer = bufnr,
            silent = true,
            noremap = true,
        })
    end,
    settings = {
        pyright = {
            disableOrganizeImports = false,
            analysis = {
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
            },
        },
    },
})

-- typescript
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        if not web_dev_attach(client, bufnr) then return end

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({
            update_imports_on_move = false,
            enable_import_on_completion = true,
        })

        ts_utils.setup_client(client)

        -- TS specific mappings
        vim.keymap.set("n", "<Leader>ii", "<cmd>TSLspOrganize<CR>", { buffer = bufnr, silent = true, noremap = true }) -- organize imports
        vim.keymap.set("n", "<Leader>R", "<cmd>TSLspRenameFile<CR>", { buffer = bufnr, silent = true, noremap = true }) -- rename file AND update references to it
    end,
})

-- vue
lspconfig.vuels.setup({
    on_attach = web_dev_attach,
    settings = {
        vetur = {
            completion = {
                autoImport = true,
                tagCasing = "kebab",
                useScaffoldSnippets = true,
            },
            useWorkspaceDependencies = true,
            experimental = {
                templateInterpolationService = true,
            },
        },
        format = {
            enable = true,
            options = {
                useTabs = false,
                tabSize = 2,
            },
            defaultFormatter = {
                ts = "prettier",
            },
            scriptInitialIndent = false,
            styleInitialIndent = false,
        },
        validation = {
            template = true,
            script = true,
            style = true,
            templateProps = true,
            interpolation = true,
        },
    },
})
lspconfig.volar.setup({
    on_attach = web_dev_attach,
    -- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
    init_options = {
        typescript = {
            -- "take over mode" can be weird in monorepos, use a global typescript installation instead
            serverPath = vim.fn.expand("~") .. "/.config/yarn/global/node_modules/typescript/lib/tsserverlibrary.js",
        },
    },
})

-- yaml
lspconfig.yamlls.setup({
    on_attach = custom_attach,
})

-- bash
lspconfig.bashls.setup({
    on_attach = custom_attach,
})

-- lua
lspconfig.sumneko_lua.setup({
    on_attach = custom_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

-- json w/ common schemas
lspconfig.jsonls.setup({
    on_attach = custom_attach,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

-- rust
lspconfig.rust_analyzer.setup({
    on_attach = custom_attach,
})

return {
    lsp_filetypes = lsp_filetypes,
}
