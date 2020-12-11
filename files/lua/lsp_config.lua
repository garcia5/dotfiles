local lspconfig = require('lspconfig')
local completion = require('completion')

-- key maps happen on attach
local mapper = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

local custom_attach = function(client)

    completion.on_attach(client)

    -- set up mappings (only apply when LSP client attached)
    mapper('n', '<c-]>' ,'lua vim.lsp.buf.definition()')
    mapper('n', '<leader><leader>k', 'lua vim.lsp.buf.hover()')
    mapper('n', '<leader><leader>f', 'lua vim.lsp.buf.signature_help()')
    mapper('n', '<leader><leader>d', 'lua vim.lsp.buf.implementation()')
    mapper('n', '<leader><leader>r', 'lua vim.lsp.buf.references()')
    mapper('n', '<leader><leader>s', 'lua vim.lsp.buf.rename()')
    mapper('n', '<leader><leader>h', 'lua vim.lsp.buf.code_action()')
    mapper('n', '<leader><leader>i', 'lua vim.lsp.buf.incoming_calls()')
    mapper('n', '<leader>dn', 'lua vim.lsp.diagnostic.goto_next()')
    mapper('n', '<leader>dp', 'lua vim.lsp.diagnostic.goto_prev()')
    mapper('n', '<leader>da', 'vim.lsp.diagnostic.set_loclist()')

    -- use omnifunc
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

-- set up clients

-- python
lspconfig.pyls.setup({
    on_attach=custom_attach,
    plugins={
        pylint={
            enabled=true
        },
        pyflakes={
            enabled=true
        },
        pydocstyle={
            enabled=true
        },
        rope_completion={
            enabled=true
        },
        black={
            enabled=true
        }
    },
    configuration_sources="pyflakes"
})
