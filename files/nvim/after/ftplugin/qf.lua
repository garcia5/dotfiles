vim.keymap.set("n", "<cr>", ":.cc<cr>", {
    desc = "Goto current quickfix item",
    buffer = true,
    silent = true,
    noremap = true,
})
