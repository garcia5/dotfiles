-- global diagnostic config
vim.diagnostic.config({
    severity_sort = true,
    underline = {
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
    },
    virtual_lines = {
        current_line = true,
        format = function(diagnostic)
            if diagnostic.source ~= nil then
                return "[" .. diagnostic.source .. "] " .. diagnostic.message
            end
            return diagnostic.message
        end,
    },
    virtual_text = false,
    float = {
        severity_sort = true,
        source = "if_many",
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
vim.keymap.set(
    "n",
    "<leader>dk",
    function() vim.diagnostic.open_float({ border = "rounded" }) end,
    { silent = true, desc = "View Current Line Diagnostics" }
)
vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, { silent = true, desc = "Populate qf list" })
vim.keymap.set("n", "<leader>do", function()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable()
    end
end, { silent = true, desc = "Toggle diagnostics" })
