local lspconfig = require("lspconfig")

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

-- set up helpers for typescript development
local setup_ts_utils = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({
        update_imports_on_move = false,
        enable_import_on_completion = true,
    })

    ts_utils.setup_client(client)

    vim.keymap.set("n", "<Leader>ii", "<cmd>TSLspOrganize<CR>", { buffer = bufnr, silent = true, noremap = true }) -- organize imports
    vim.keymap.set("n", "<Leader>R", "<cmd>TSLspRenameFile<CR>", { buffer = bufnr, silent = true, noremap = true }) -- rename file AND update references to it
end

-- restricted format
local custom_format = function(bufnr, allowed_clients)
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
            if not allowed_clients then return true end
            return vim.tbl_contains(allowed_clients, client.name)
        end,
    })
end

local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
---@param bufnr number
---@param allowed_clients string[]
local format_on_save = function(bufnr, allowed_clients)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function() custom_format(bufnr, allowed_clients) end,
    })
end

---@param client any the lsp client instance
---@param bufnr number buffer we're attaching to
---@param formatters string[] table containing client names for which formatting should be enabled
local custom_attach = function(client, bufnr, formatters)
    -- LSP mappings (only apply when LSP client attached)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    local with_desc = function(opts, desc) return vim.tbl_extend("force", opts, { desc = desc }) end
    vim.keymap.set("n", "K", vim.lsp.buf.hover, with_desc(keymap_opts, "Hover"))
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, with_desc(keymap_opts, "Goto Definition"))
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, with_desc(keymap_opts, "Find References"))
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, with_desc(keymap_opts, "Rename"))

    -- diagnostics
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.open_float, with_desc(keymap_opts, "View Current Diagnostic")) -- diagnostic(s) on current line
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, with_desc(keymap_opts, "Goto next diagnostic")) -- move to next diagnostic in buffer
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, with_desc(keymap_opts, "Goto prev diagnostic")) -- move to prev diagnostic in buffer
    vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, with_desc(keymap_opts, "Populate qf list")) -- show all buffer diagnostics in qflist
    vim.keymap.set("n", "H", function()
        -- make sure telescope is loaded for code actions
        require("telescope").load_extension("ui-select")
        vim.lsp.buf.code_action()
    end, with_desc(keymap_opts, "Code Actions")) -- code actions (handled by telescope-ui-select)
    vim.keymap.set("n", "<leader>F", function() custom_format(bufnr, formatters) end, with_desc(keymap_opts, "Format")) -- format

    -- use omnifunc
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"
end

---@param client any
---@param bufnr number
local web_dev_attach = function(client, bufnr)
    local root_files = vim.fn.readdir(vim.fn.getcwd())
    local volar = false
    -- TODO: the "right" way to do this would be to check the typescript version, but that seems hard
    if vim.tbl_contains(root_files, "pnpm-lock.yaml") then volar = true end

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

    custom_attach(client, bufnr, { "null-ls" })
    return true
end

-- Set up clients
local null_ls = require("null-ls")
null_ls.setup({
    on_attach = function(client, bufnr) custom_attach(client, bufnr, { "null-ls" }) end,
    should_attach = function(bufnr)
        local cur_ft = vim.bo[bufnr].filetype
        return vim.tbl_contains({ "vue", "typescript", "javascript", "python", "lua" }, cur_ft)
    end,
    sources = {
        --#formatters
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.black,

        --#diagnostics/linters
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.eslint_d,

        --#code actions
        null_ls.builtins.code_actions.eslint_d,
    },
    fallback_severity = vim.diagnostic.severity.HINT,
})

-- python
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "null-ls" })
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
        setup_ts_utils(client, bufnr)
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
    on_attach = function(client, bufnr)
        if not web_dev_attach(client, bufnr) then return end
        setup_ts_utils(client, bufnr)
    end,
    -- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

-- yaml
lspconfig.yamlls.setup({
    on_attach = custom_attach,
})

-- bash
lspconfig.bashls.setup({
    on_attach = custom_attach,
    filetypes = { "bash", "sh", "zsh" },
})

-- lua
lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "null-ls" })
        format_on_save(bufnr, { "null-ls" })
    end,
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
                checkThirdParty = false,
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

-- go
lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "gopls" })
        -- auto organize imports/format on save
        format_on_save(bufnr, { "gopls" })
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
            end,
        })
    end,
})

-- dart
lspconfig.dartls.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "dartls" })
        format_on_save(bufnr, { "dartls" })
    end,
})
