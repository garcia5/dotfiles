vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2

vim.keymap.set(
    "n",
    "<Leader>cf",
    "<cmd>Forecast<CR>",
    { silent = true, noremap = true, desc = "Validate cloudformation template", buffer = 0 }
)
