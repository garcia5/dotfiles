-- global diagnostic config
vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
        -- Only display errors w/ virtual text
        severity = vim.diagnostic.severity.ERROR,
        -- Prepend with diagnostic source if there is more than one attached to the buffer
        -- (e.g. (eslint) Error: blah blah blah)
        source = "if_many",
        hl_mode = "blend",
    },
    underline = true,
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
vim.keymap.set("n", "<leader>dk", vim.diagnostic.open_float, { silent = true, desc = "View Current Diagnostic" })
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { silent = true, desc = "Goto next diagnostic" })
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { silent = true, desc = "Goto prev diagnostic" })
vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, { silent = true, desc = "Populate qf list" })
vim.keymap.set("n", "<leader>do", function()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable()
    end
end, { silent = true, desc = "Toggle diagnostics" })
