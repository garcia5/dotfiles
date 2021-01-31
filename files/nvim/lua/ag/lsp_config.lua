local lspconfig = require('lspconfig')
local compe = require('compe')

local mapper = function(mode, key, result, opts)
    vim.api.nvim_buf_set_keymap(0, mode, key, result, opts)
end

local lsp_mapper = function(mode, key, result)
    mapper(mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

local custom_attach = function(client)
    -- Only autocomplete when I have a language server running
    compe.setup({
        enabled = true,
        preselect = 'disable',
        source = {
            path = true,
            buffer = true,
            vsnip = false,
            nvim_lsp = true,
        },
    }, 0) -- Only current buffer

    -- Set up mappings (only apply when LSP client attached)
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

    -- Diagnostic text colors
    -- Errors in Red
    vim.cmd[[ hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red ]]
    -- Warnings in Yellow
    vim.cmd[[ hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow ]]
    -- Info and Hints in White
    vim.cmd[[ hi LspDiagnosticsVirtualTextInformation guifg=White ctermfg=White ]]
    vim.cmd[[ hi LspDiagnosticsVirtualTextHint guifg=White ctermfg=White ]]
    -- Underline the offending code
    vim.cmd[[ hi LspDiagnosticsUnderlineError guifg=NONE ctermfg=NONE cterm=underline gui=underline ]]
    vim.cmd[[ hi LspDiagnosticsUnderlineWarning guifg=NONE ctermfg=NONE cterm=underline gui=underline ]]
    vim.cmd[[ hi LspDiagnosticsUnderlineInformation guifg=NONE ctermfg=NONE cterm=underline gui=underline ]]
    vim.cmd[[ hi LspDiagnosticsUnderlineHint guifg=NONE ctermfg=NONE cterm=underline gui=underline ]]

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

-- yaml
lspconfig.yamlls.setup{on_attach=custom_attach}

-- bash
lspconfig.bashls.setup{on_attach=custom_attach}
