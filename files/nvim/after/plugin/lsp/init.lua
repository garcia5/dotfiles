local common = require("ag.lsp.common")

local lsp_dir = vim.fn.stdpath("config") .. "/after/lsp"
local client_names = {}

for name, type in vim.fs.dir(lsp_dir) do
    if type == "file" and name:match("%.lua$") then
        local fname = name:gsub("%.lua$", "")
        table.insert(client_names, fname)
    end
end

for _, client in ipairs(client_names) do
    common.register_if_installed(client)
end
