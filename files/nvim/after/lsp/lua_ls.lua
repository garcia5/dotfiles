local custom_attach = require("ag.lsp.common").custom_attach

return {
    cmd = { "lua-language-server", "--stdio" },
    filetypes = { "lua" },
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, {
            format = {
                format_on_save = true,
            },
        })
    end,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
        },
    },
}
