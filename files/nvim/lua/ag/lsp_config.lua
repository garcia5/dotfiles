local lspconfig = require("lspconfig")
local cmp_capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local local_mapper = function(mode, key, result, opts)
    vim.api.nvim_buf_set_keymap(0, mode, key, result, opts)
end

local lsp_mapper = function(mode, key, result)
    local_mapper(mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

-- Give floating windows borders
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        border = "rounded"
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
        border = "rounded"
    }
)

-- Configure diagnostic display
vim.diagnostic.config(
    {
        virtual_text = {
            severity = vim.diagnostic.severity.ERROR,
            source = "if_many"
        },
        float = {
            severity_sort = true,
            source = "if_many",
            border = "rounded",
            header = {
                "",
                "LspDiagnosticsDefaultWarning"
            },
            prefix = function(diagnostic)
                local diag_to_format = {
                    [vim.diagnostic.severity.ERROR] = {"Error", "LspDiagnosticsDefaultError"},
                    [vim.diagnostic.severity.WARN] = {"Warning", "LspDiagnosticsDefaultWarning"},
                    [vim.diagnostic.severity.INFO] = {"Info", "LspDiagnosticsDefaultInfo"},
                    [vim.diagnostic.severity.HINT] = {"Hint", "LspDiagnosticsDefaultHint"}
                }
                local res = diag_to_format[diagnostic.severity]
                return string.format("(%s) ", res[1]), res[2]
            end
        },
        severity_sort = true
    }
)

local custom_attach = function(client, bufnr)
    -- Load autocomplete engine/settings
    require("ag.completion")
    -- Load debuggers
    require("ag.debug")

    -- LSP mappings (only apply when LSP client attached)
    lsp_mapper("n", "K", "vim.lsp.buf.hover()")
    lsp_mapper("n", "<c-]>", "vim.lsp.buf.definition()")
    lsp_mapper("n", "<leader>gr", "vim.lsp.buf.references()")
    lsp_mapper("n", "gr", "vim.lsp.buf.rename()")
    lsp_mapper("n", "H", "vim.lsp.buf.code_action()")
    lsp_mapper("i", "<C-h>", "vim.lsp.buf.signature_help()")

    -- diagnostics
    lsp_mapper("n", "<leader>dk", "vim.diagnostic.open_float()") -- diagnostic(s) on current line
    lsp_mapper("n", "<leader>dn", "vim.diagnostic.goto_next()") -- move to next diagnostic in buffer
    lsp_mapper("n", "<leader>dp", "vim.diagnostic.goto_prev()") -- move to prev diagnostic in buffer
    lsp_mapper("n", "<leader>da", "vim.diagnostic.setqflist()") -- show all buffer diagnostics in qflist

    -- use omnifunc
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"
end

-- Set up clients
lspconfig.diagnosticls.setup(
    {
        on_attach = custom_attach,
        filetypes = {
            "python"
        },
        init_options = {
            filetypes = {
                python = "flake8"
            },
            linters = {
                flake8 = {
                    sourceName = "flake8",
                    command = "flake8",
                    args = {
                        [[--format = %(row)d,%(col)d,%(code).1s,%(code)s: %(text)s]],
                        "-"
                    },
                    debounce = 100,
                    offsetLine = 0,
                    offsetColumn = 0,
                    formatLines = 1,
                    formatPattern = {
                        [[(\d+),(\d+),([A-Z]),(.*)(\r|\n)*$]],
                        {
                            line = 1,
                            column = 2,
                            security = 3,
                            message = {"[flake8] ", 4}
                        }
                    },
                    securities = {
                        W = "warning",
                        E = "error",
                        F = "error",
                        C = "error",
                        N = "error"
                    }
                }
            }
        }
    }
)

-- python
lspconfig.pyright.setup(
    {
        capabilities = cmp_capabilities,
        on_attach = function(client, bufnr)
            custom_attach(client, bufnr)
            -- 'Organize imports' keymap for pyright only
            local_mapper(
                "n",
                "<Leader>ii",
                "<cmd>PyrightOrganizeImports<CR>",
                {
                    silent = true,
                    noremap = true
                }
            )
        end,
        settings = {
            pyright = {
                disableOrganizeImports = false,
                analysis = {
                    useLibraryCodeForTypes = true,
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    autoImportCompletions = true
                }
            }
        }
    }
)

-- eslint
lspconfig.eslint.setup(
    {
        on_attach = custom_attach,
        settings = {
            packageManager = "yarn"
        }
    }
)

-- typescript
lspconfig.tsserver.setup(
    {
        capabilities = cmp_capabilities,
        on_attach = custom_attach
    }
)

-- vue
lspconfig.vuels.setup(
    {
        capabilities = cmp_capabilities,
        on_attach = function(client, bufnr)
            -- Tell vim that vls can handle formatting
            client.resolved_capabilities.document_formatting = true
            custom_attach(client, bufnr)
        end,
        settings = {
            vetur = {
                completion = {
                    autoImport = true,
                    tagCasing = "kebab",
                    useScaffoldSnippets = true
                },
                useWorkspaceDependencies = true,
                experimental = {
                    templateInterpolationService = true
                }
            },
            format = {
                enable = true,
                options = {
                    useTabs = false,
                    tabSize = 2
                }
            },
            validation = {
                template = true,
                script = true,
                style = true,
                templateProps = true,
                interpolation = true
            }
        }
    }
)

-- yaml
lspconfig.yamlls.setup(
    {
        capabilities = cmp_capabilities,
        on_attach = custom_attach
    }
)

-- bash
lspconfig.bashls.setup(
    {
        capabilities = cmp_capabilities,
        on_attach = custom_attach
    }
)

-- lua (optional)
local lua_ls_path = vim.fn.expand("~/lua-language-server/")
local lua_ls_bin = lua_ls_path .. "bin/macOS/lua-language-server"
if vim.fn.executable(lua_ls_bin) then
    lspconfig.sumneko_lua.setup(
        {
            capabilities = cmp_capabilities,
            on_attach = custom_attach,
            cmd = {lua_ls_bin, "-E", lua_ls_path .. "main.lua"},
            settings = {
                Lua = {
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {
                            "vim"
                        }
                    }
                }
            }
        }
    )
end
