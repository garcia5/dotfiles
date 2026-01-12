local custom_attach = require("ag.lsp.common").custom_attach
local ruff_cmd = require("ag.utils").command_in_virtual_env("ruff", false)

if ruff_cmd == nil then return {} end

return {
    filetypes = { "python" },
    cmd = { ruff_cmd, "server" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml" },
    on_attach = function(client, bufnr)
        local is_diffview = vim.fn.bufname(bufnr):match("^diffview")
        if is_diffview then
            client:stop(true)
        else
            custom_attach(client, bufnr, {
                code_actions = {
                    register_organize_imports = true,
                },
            })
        end
    end,
    init_options = {
        settings = {
            organizeImports = true,
        },
    },
}
