local custom_attach = require("ag.lsp.common").custom_attach

return {
    cmd = { "typescript-language-server", "--stdio" },
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { allowed_clients = { "efm" }, format_on_save = false })
    end,
    filetypes = { "javascript", "typescript", "vue" },
    root_dir = function(bufnr, cb)
        local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json", "jsconfig.json" })
        cb(root)
    end,
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vim.fn.expand(
                    "$NVM_DIR/versions/node/$DEFAULT_NODE_VERISON/lib/node_modeuls/@vue/typescript-plugin"
                ),
                languages = {
                    "javascript",
                    "typescript",
                    "vue",
                },
            },
        },
    },
}
