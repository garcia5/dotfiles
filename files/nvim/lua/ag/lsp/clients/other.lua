local custom_attach = require("ag.lsp.common").custom_attach

vim.lsp.config.volar = {
    cmd = { "vue-language-server", "--stdio" },
    on_attach = function(client, bufnr) custom_attach(client, bufnr, { allowed_clients = { "efm" } }) end,
    -- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
    filetypes = { "typescript", "javascript", "vue" },
    -- on_new_config = function(new_config, new_root_dir)
    --     new_config.init_options.typescript.tsdk = require("ag.utils").get_typescript_server_path(new_root_dir)
    -- end,
}

vim.lsp.config.bashls = {
    cmd = { "bash-language-server", "start" },
    on_attach = custom_attach,
    filetypes = { "bash", "sh", "zsh" },
}

vim.lsp.config.jsonls = {
    filetypes = { "json" },
    cmd = { "vscode-json-language-server", "--stdio" },
    on_attach = custom_attach,
}

-- rust
vim.lsp.config.rust_analyzer = {
    filetypes = { "rust" },
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { format_on_save = true, allowed_clients = { "rust_analyzer" } })
    end,
}

-- go
vim.lsp.config.gopls = {
    filetypes = { "go" },
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { allowed_clients = { "gopls" }, format_on_save = true })
        -- auto organize imports
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true,
                })
            end,
        })
    end,
}

-- dart
vim.lsp.config.dartls = {
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { allowed_clients = { "dartls" }, format_on_save = true })
    end,
}
