vim.lsp.log.set_level(vim.log.levels.INFO)

local clients = {
    "bashls",
    "dartls",
    "efm",
    "gopls",
    "jsonls",
    "lua_ls",
    "basedpyright",
    "ruff",
    "rust_analyzer",
    "vtsls",
    "volar",
    "yamlls",
}
vim.lsp.enable(clients)
