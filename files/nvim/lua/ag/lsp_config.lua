local lspconfig = require('lspconfig')
local completion = require('completion')

local mapper = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

local custom_attach = function(client)

    completion.on_attach(client)
    -- smart case autocomplete
    vim.g.completion_matching_smart_case = 1

    -- set up mappings (only apply when LSP client attached)
    mapper("n" , "K"         , "vim.lsp.buf.hover()")
    mapper("n" , "<c-]>"     , "vim.lsp.buf.definition()")
    mapper("n" , "gR"        , "vim.lsp.buf.references()")
    mapper("n" , "gr"        , "vim.lsp.buf.rename()")
    mapper("n" , "H"         , "vim.lsp.buf.code_action()")
    mapper("n" , "gin"       , "vim.lsp.buf.incoming_calls()")
    mapper("n" , "<space>dn" , "vim.lsp.diagnostic.goto_next()")
    mapper("n" , "<space>dp" , "vim.lsp.diagnostic.goto_prev()")
    mapper("n" , "<space>da" , "vim.lsp.diagnostic.set_loclist()")

    -- Diagnostic text colors
    vim.cmd [[ hi link LspDiagnosticsDefaultError WarningMsg ]]
    vim.cmd [[ hi link LspDiagnosticsDefaultWarning WarningMsg ]]
    vim.cmd [[ hi link LspDiagnosticsDefaultInformation NonText ]]
    vim.cmd [[ hi link LspDiagnosticsDefaultHint NonText ]]

    -- use omnifunc
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

-- Set up clients
-- python
lspconfig.pyright.setup{on_attach=custom_attach}

-- typescript
lspconfig.tsserver.setup{on_attach=custom_attach}

-- vue
lspconfig.vuels.setup({
    on_attach=custom_attach,
    settings={
        vetur = {
            completion = {
                autoImport = true,
                tagCasing = "kebab",
                useScaffoldSnippets = false,
            },
            useWorkspaceDependencies = true,
        },
    },
})

-- vim
lspconfig.vimls.setup{on_attach=custom_attach}

-- yaml
lspconfig.yamlls.setup{on_attach=custom_attach}

-- bash
lspconfig.bashls.setup{on_attach=custom_attach}
