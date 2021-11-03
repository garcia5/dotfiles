local lspconfig = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local mapper = function(mode, key, result, opts)
    vim.api.nvim_buf_set_keymap(0, mode, key, result, opts)
end

local lsp_mapper = function(mode, key, result)
    mapper(mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

-- Give popup windows bordres
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        border = "single",
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
        border = "single",
    }
)

local custom_attach = function(client, bufnr)
    -- Load autocomplete engine/settings
    require('ag.completion')
    -- Load debuggers
    require('ag.debug')

    -- LSP mappings (only apply when LSP client attached)
    lsp_mapper("n", "K"         , "vim.lsp.buf.hover()")
    mapper    ("n", "<c-]>"     , "<cmd>lua vim.lsp.buf.definition()<CR>zz", {noremap = true, silent = true})
    lsp_mapper("n", "<leader>gr", "vim.lsp.buf.references()")
    lsp_mapper("n", "gr"        , "vim.lsp.buf.rename()")
    lsp_mapper("n", "H"         , "vim.lsp.buf.code_action()")
    lsp_mapper("n", "gin"       , "vim.lsp.buf.incoming_calls()")
    lsp_mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next({popup_opts = {border = 'single'}})")
    lsp_mapper("n", "<leader>dp", "vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'single'}})")
    lsp_mapper("n", "<leader>da", "vim.lsp.diagnostic.set_loclist()")
    lsp_mapper("i", "<C-h>"     , "vim.lsp.buf.signature_help()")

    -- use omnifunc
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Set up clients
lspconfig.diagnosticls.setup({
    on_attach = custom_attach,
    filetypes = {"python", "javascript", "typescript", "vue"},
    init_options = {
        filetypes = {
            python     = "flake8",
            javascript = "eslint_d",
            typescript = "eslint_d",
            vue        = "eslint_d",
        },
        linters = {
            flake8 = {
                sourceName    = 'flake8',
                command       = 'flake8',
                args          = {[[--format = %(row)d,%(col)d,%(code).1s,%(code)s: %(text)s]], '-'},
                debounce      = 100,
                offsetLine    = 0,
                offsetColumn  = 0,
                formatLines   = 1,
                formatPattern = {
                    [[(\d+),(\d+),([A-Z]),(.*)(\r|\n)*$]],
                    {line = 1, column = 2, security = 3, message = {'[flake8] ', 4}},
                },
                securities    = {
                    W = 'warning',
                    E = 'error',
                    F = 'error',
                    C = 'error',
                    N = 'error',
                },
            },
            eslint_d = {
                sourceName   = 'eslint_d',
                command      = 'eslint_d',
                debounce     = 100,
                args         = {'--stdin', '--stdin-filename', '%filepath', '--format', 'json'},
                parseJson    = {
                    errorsRoot = '[0].messages',
                    line       = 'line',
                    column     = 'column',
                    endLine    = 'endLine',
                    endColumn  = 'endColumn',
                    message    = '[eslint] ${message} [${ruleId}]',
                    security   = 'severity',
                },
                securities   = {[2] = 'error', [1] = 'warning'},
                rootPatterns = {
                    '.eslintrc',
                    '.eslintrc.cjs',
                    '.eslintrc.js',
                    '.eslintrc.json',
                    '.eslintrc.yaml',
                    '.eslintrc.yml',
                },
            },
        },
    },
})

-- python
lspconfig.pyright.setup({
    capabilities = cmp_capabilities,
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)
        -- 'Organize imports' keymap for pyright only
        mapper("n", "<Leader>ii", "<cmd>PyrightOrganizeImports<CR>",
            {silent = true, noremap = true}
        )
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
    on_attach = custom_attach
})

-- vue
lspconfig.vuels.setup({
    capabilities = cmp_capabilities,
    on_attach = function(client, bufnr)
        -- Tell vim that vls can handle formatting
        client.resolved_capabilities.document_formatting = true
        custom_attach(client, bufnr)
    end,
    settings = {
        vetur = {
            completion = {
                autoImport          = true,
                tagCasing           = "kebab",
                useScaffoldSnippets = true,
            },
            useWorkspaceDependencies = true,
            experimental = {
                templateInterpolationService = true,
            }
        },
        format = {
            enable  = true,
            options = {
                useTabs = false,
                tabSize = 2,
            },
        },
        validation = {
            template      = true,
            script        = true,
            style         = true,
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
    on_attach = custom_attach
})

-- lua (optional)
local lua_ls_path = vim.fn.expand('~/lua-language-server/')
local lua_ls_bin = lua_ls_path .. 'bin/macOS/lua-language-server'
if vim.fn.executable(lua_ls_bin) then
    lspconfig.sumneko_lua.setup({
        capabilities = cmp_capabilities,
        on_attach = custom_attach,
        cmd = {lua_ls_bin, '-E',  lua_ls_path .. 'main.lua'},
        settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                },
            },
        },
    })
end
