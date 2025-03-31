local clients = require("ag.lsp.clients")
-- require("ag.lsp.completion")
local common = require("ag.lsp.common")

for _, client in ipairs(clients) do
    common.register_if_installed(client)
end

vim.lsp.log.set_level(vim.log.levels.INFO)
