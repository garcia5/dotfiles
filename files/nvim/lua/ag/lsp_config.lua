local lspconfig = require('lspconfig')
local compe = require('compe')

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
    -- Only autocomplete in lsp
    compe.setup({
        enabled = true,
        preselect = 'disable',
        source = {
            -- Passing a dict enables the completion source
            -- Menu is sorted by priority highest -> lowest
            vsnip           = {priority = 100},
            nvim_lsp        = {priority = 90},
            nvim_treesitter = {priority = 86},
            nvim_lua        = {priority = 85},
            buffer          = {priority = 80},
            path            = {priority = 70},
        },
    }, bufnr) -- Only current buffer

    -- Compe mappings
    -- Trigger completion
    mapper("i", "<C-Space>", "compe#complete()",
        {silent = true, expr = true, noremap = true}
    )
    -- Confirm completion
    mapper("i", "<C-y>"     , "compe#confirm()",
        {silent = true, expr = true, noremap = true}
    )
    -- Close completion menu
    mapper("i", "<C-e>"    , "compe#close()",
        {silent = true, expr = true, noremap = true}
    )

    -- LSP mappings (only apply when LSP client attached)
    lsp_mapper("n" , "K"          , "vim.lsp.buf.hover()")
    lsp_mapper("n" , "<c-]>"      , "vim.lsp.buf.definition()")
    lsp_mapper("n" , "<leader>r"  , "vim.lsp.buf.references()")
    lsp_mapper("n" , "H"          , "vim.lsp.buf.code_action()")
    lsp_mapper("n" , "gin"        , "vim.lsp.buf.incoming_calls()")
    lsp_mapper("n" , "<leader>dn" , "vim.lsp.diagnostic.goto_next({popup_opts = {border = 'single'}})")
    lsp_mapper("n" , "<leader>dp" , "vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'single'}})")
    lsp_mapper("n" , "<leader>da" , "vim.lsp.diagnostic.set_loclist()")
    lsp_mapper("i" , "<C-h>"      , "vim.lsp.buf.signature_help()")

    -- use omnifunc
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Set up clients
-- python
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)
        -- 'Organize imports' keymap for pyright only
        mapper("n", "<Leader>ii", "<cmd>PyrightOrganizeImports<CR>",
            {silent = true, noremap = true}
        )
    end,
    settings = {
        pyright = {
            disableOrganizeImports = false
        },
    }
})

-- typescript
lspconfig.tsserver.setup{on_attach = custom_attach}

-- vue
lspconfig.vuels.setup({
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
                useScaffoldSnippets = true,
            },
            useWorkspaceDependencies = true,
        },
        format = {
            enable = true,
            options = {
                useTabs = false,
                tabSize = 2,
            },
        },
        validation = {
            template = true,
            script = true,
            style = true,
            templateProps = true,
            interpolation = true
        },
    },
})

-- yaml
lspconfig.yamlls.setup{on_attach = custom_attach}

-- bash
lspconfig.bashls.setup{on_attach = custom_attach}

-- lua (optional)
local lua_ls_path = vim.fn.expand('~/lua-language-server/')
local lua_ls_bin = lua_ls_path .. 'bin/Linux/lua-language-server'
if vim.fn.executable(lua_ls_bin) then
    lspconfig.sumneko_lua.setup({
        on_attach = custom_attach,
        cmd = { lua_ls_bin, '-E',  lua_ls_path .. 'main.lua'},
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
