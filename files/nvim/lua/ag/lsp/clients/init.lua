-- base config for all lsp clients
vim.lsp.config("*", {
    root_markers = { ".git" },
})

require("ag.lsp.clients.efm")
require("ag.lsp.clients.lua_ls")
require("ag.lsp.clients.other")
require("ag.lsp.clients.pyright")
require("ag.lsp.clients.yamlls")

return {
    "efm",
    "lua_ls",
    "pyright",
    "yamlls",
    "volar",
    "bashls",
    "jsonls",
    "rust_analyzer",
    "gopls",
    "dartls",
}
