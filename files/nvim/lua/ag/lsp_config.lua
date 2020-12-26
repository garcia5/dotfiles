local lspconfig = require('lspconfig')
local completion = require('completion')

local mapper = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end


local custom_attach = function(client)

    completion.on_attach(client)

    -- set up mappings (only apply when LSP client attached)
    mapper("n", "K", "vim.lsp.buf.hover()")
    mapper("n", "<c-]", "vim.lsp.buf.definition")
    mapper("n", "gR", "vim.lsp.buf.references()")
    mapper("n", "gr", "vim.lsp.buf.rename()")
    mapper("n", "<space>h", "vim.lsp.buf.code_action()")
    mapper("n", "gin", "vim.lsp.buf.incoming_calls()")
    mapper("n", "<space>dn", "vim.lsp.diagnostic.goto_next()")
    mapper("n", "<space>dp", "vim.lsp.diagnostic.goto_prev()")
    mapper("n", "<space>da", "vim.lsp.diagnostic.set_loclist()")

    -- use omnifunc
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

-- set up clients

-- python
lspconfig.pyls.setup({
    on_attach=custom_attach,
    plugins={
        configuration_sources={
            "pylint", "yapf"
        },
        pylint={
            enabled=true,
        },
        yapf={
            enabled=true
        },
        black={
            enabled=false
        },
        pycodestyle={
            enabled=false
        },
        rope_completion={
            enabled=false
        },
        mccabe={
            enabled=false
        },
    }
})
