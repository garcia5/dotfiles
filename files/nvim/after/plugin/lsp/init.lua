vim.lsp.log.set_level(vim.log.levels.INFO)

local clients = {
    "bashls",
    "dartls",
    "efm",
    "gopls",
    "jsonls",
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "ts_ls",
    "volar",
    "yamlls",
}
vim.lsp.enable(clients)
