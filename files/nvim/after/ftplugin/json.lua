vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

vim.keymap.set("n", "<Leader>F", "!% jq --indent 2 .<CR>", {
    desc = "Format file using jq",
    buf = 0,
    silent = true,
})
