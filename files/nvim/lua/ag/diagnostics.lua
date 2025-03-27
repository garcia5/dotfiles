-- global diagnostic config
vim.diagnostic.config({
    severity_sort = true,
    virtual_lines = false,
    virtual_text = {
        severity = vim.diagnostic.severity.ERROR,
        source = "if_many",
        hl_mode = "blend",
    },
    float = {
        severity_sort = true,
        source = "if_many",
        border = "single",
        header = {
            "",
            "DiagnosticSignWarn",
        },
        prefix = function(diagnostic)
            local diag_to_format = {
                [vim.diagnostic.severity.ERROR] = { "Error", "DiagnosticError" },
                [vim.diagnostic.severity.WARN] = { "Warning", "DiagnosticWarn" },
                [vim.diagnostic.severity.INFO] = { "Info", "DaignosticInfo" },
                [vim.diagnostic.severity.HINT] = { "Hint", "DiagnosticHint" },
            }
            local res = diag_to_format[diagnostic.severity]
            return string.format("(%s) ", res[1]), res[2]
        end,
    },
})

-- keymaps
vim.keymap.set("n", "<leader>dk", function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { silent = true, desc = "View Current Line Diagnostics" })
vim.keymap.set(
    "n",
    "<leader>dn",
    function() vim.diagnostic.jump({ count = 1 }) end,
    { silent = true, desc = "Goto next diagnostic" }
)
vim.keymap.set(
    "n",
    "<leader>dp",
    function() vim.diagnostic.jump({ count = -1 }) end,
    { silent = true, desc = "Goto prev diagnostic" }
)
vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, { silent = true, desc = "Populate qf list" })
vim.keymap.set("n", "<leader>do", function()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable()
    end
end, { silent = true, desc = "Toggle diagnostics" })
