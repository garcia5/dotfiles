vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2

vim.keymap.set(
    "n",
    "<Leader>cf",
    "<cmd>Forecast! %<CR>",
    { silent = true, noremap = true, desc = "Run forecast cli on current file", buffer = 0 }
)

vim.api.nvim_create_autocmd("User", {
    pattern = "ForecastFinished",
    callback = function() vim.notify("Forecast Complete", vim.log.levels.INFO) end,
})
