local lspconfig = require('lspconfig')
local trouble = require('trouble')
local compe = require('compe')

local mapper = function(mode, key, result, opts)
    vim.api.nvim_buf_set_keymap(0, mode, key, result, opts)
end

local lsp_mapper = function(mode, key, result)
    mapper(mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

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
    }, 0) -- Only current buffer
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

    -- load lsp trouble
    trouble.setup()

    -- LSP mappings (only apply when LSP client attached)
    lsp_mapper("n" , "K"         , "vim.lsp.buf.hover()")
    lsp_mapper("n" , "<c-]>"     , "vim.lsp.buf.definition()")
    lsp_mapper("n" , "gR"        , "vim.lsp.buf.references()")
    lsp_mapper("n" , "gr"        , "vim.lsp.buf.rename()")
    lsp_mapper("n" , "H"         , "vim.lsp.buf.code_action()")
    lsp_mapper("n" , "gin"       , "vim.lsp.buf.incoming_calls()")
    lsp_mapper("n" , "<space>dn" , "vim.lsp.diagnostic.goto_next()")
    lsp_mapper("n" , "<space>dp" , "vim.lsp.diagnostic.goto_prev()")
    lsp_mapper("n" , "<space>da" , "vim.lsp.diagnostic.set_loclist()")
    lsp_mapper("i" , "<C-h>"     , "vim.lsp.buf.signature_help()")
    lsp_mapper("n" , "<C-q>"     , "vim.lsp.stop_client(vim.lsp.buf_get_clients(0))")

    -- Diagnostic text colors
    -- Errors in Red
    vim.cmd[[ hi LspDiagnosticsVirtualTextError guifg = Red ctermfg = Red ]]
    -- Warnings in Yellow
    vim.cmd[[ hi LspDiagnosticsVirtualTextWarning guifg = Yellow ctermfg = Yellow ]]
    -- Info and Hints in White
    vim.cmd[[ hi LspDiagnosticsVirtualTextInformation guifg = White ctermfg = White ]]
    vim.cmd[[ hi LspDiagnosticsVirtualTextHint guifg = White ctermfg = White ]]
    -- Underline the offending code
    vim.cmd[[ hi LspDiagnosticsUnderlineError guifg = NONE ctermfg = NONE cterm = underline gui = underline ]]
    vim.cmd[[ hi LspDiagnosticsUnderlineWarning guifg = NONE ctermfg = NONE cterm = underline gui = underline ]]
    vim.cmd[[ hi LspDiagnosticsUnderlineInformation guifg = NONE ctermfg = NONE cterm = underline gui = underline ]]
    vim.cmd[[ hi LspDiagnosticsUnderlineHint guifg = NONE ctermfg = NONE cterm = underline gui = underline ]]

    -- use omnifunc
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

-- Set up clients
-- python
lspconfig.pyright.setup({
    on_attach = function(client)
        custom_attach(client)
        -- 'Organize imports' keymap for pyright only
        mapper("n", "<Leader>ii", "<cmd>PyrightOrganizeImports<CR>",
            {silent = true, noremap = true}
        )
    end,
    settings = {
        pyright = {
            disableOrganizeImports = false
        },
        python = {
            analysis = {
                useLibraryCodeForTypes = true
            }
        }
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
