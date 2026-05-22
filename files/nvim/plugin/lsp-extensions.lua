vim.pack.add({
    { src = "gh:creativenull/efmls-configs-nvim", version = vim.version.range("v1.x.x") },
    "gh:yioneko/nvim-vtsls",
})

-- vtsls mappings/commands
vim.api.nvim_create_user_command("VtsRename", function() require("vtsls").rename() end, {})
vim.api.nvim_create_user_command("VtsExec", function(opts) require("vtsls").exec_command(opts.args) end, { nargs = 1 })
