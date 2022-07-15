local lspconfig = require("lspconfig")

local cmp_capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
cmp_capabilities.textDocument.completion.completionItem.snippetSupport = true -- tell language servers we can handle snippets

-- Give floating windows borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

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
        border = "rounded",
        header = {
            "Diagnostics",
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

    -- use omnifunc
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"
end

-- Set up clients
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        --#formatters
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,

        --#diagnostics/linters
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.eslint_d,

        --#code actions
        null_ls.builtins.code_actions.eslint_d,
    },
})

-- python
lspconfig.pyright.setup({
    capabilities = cmp_capabilities,
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
    capabilities = cmp_capabilities,
    -- required to enable inlay hints
    init_options = require("nvim-lsp-ts-utils").init_options,
    on_attach = function(client, bufnr)
        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({
            update_imports_on_move = false,
            enable_import_on_completion = true,
            auto_inlay_hints = false, -- doesn't _quite_ work
            inlay_hints_highlight = "Comment",
            inlay_hints_format = {
                Type = {
                    highlight = "Comment",
                    text = function(text)
                        return "->" .. text
                    end,
                },
                Parameter = {
                    highlight = "Comment",
                },
                Enum = {
                    highlight = "Comment",
                },
            },
        })

        ts_utils.setup_client(client)

        -- TS specific mappings
        vim.keymap.set("n", "<Leader>ii", "<cmd>TSLspOrganize<CR>", { buffer = bufnr, silent = true, noremap = true }) -- organize imports
        vim.keymap.set("n", "<Leader>R", "<cmd>TSLspRenameFile<CR>", { buffer = bufnr, silent = true, noremap = true }) -- rename file AND update references to it

        custom_attach(client, bufnr)
    end,
})

-- vue
lspconfig.vuels.setup({
    capabilities = cmp_capabilities,
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)
    end,
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
            enable = false, -- delegated to prettierd via null_ls
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

-- yaml
lspconfig.yamlls.setup({
    capabilities = cmp_capabilities,
    on_attach = custom_attach,
})

-- bash
lspconfig.bashls.setup({
    capabilities = cmp_capabilities,
    on_attach = custom_attach,
})

-- lua
lspconfig.sumneko_lua.setup({
    capabilities = cmp_capabilities,
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

-- rust
lspconfig.rust_analyzer.setup({
    capabilities = cmp_capabilities,
    on_attach = custom_attach,
})

-- json w/ common schemas
lspconfig.jsonls.setup({
    capabilities = cmp_capabilities,
    on_attach = custom_attach,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})
