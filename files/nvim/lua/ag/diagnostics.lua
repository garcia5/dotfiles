vim.diagnostic.config({
    virtual_text = {
        -- Only display errors w/ virtual text
        severity = vim.diagnostic.severity.ERROR,
        -- Prepend with diagnostic source if there is more than one attached to the buffer
        -- (e.g. (eslint) Error: blah blah blah)
        source = "if_many",
        signs = false,
    },
    float = {
        severity_sort = true,
        source = "if_many",
        border = "solid",
        header = {
            "",
            "LspDiagnosticsDefaultWarning",
        },
        prefix = function(diagnostic)
            local diag_to_format = {
                [vim.diagnostic.severity.ERROR] = { "Error", "LspDiagnosticsDefaultError" },
                [vim.diagnostic.severity.WARN] = { "Warning", "LspDiagnosticsDefaultWarning" },
                [vim.diagnostic.severity.INFO] = { "Info", "LspDiagnosticsDefaultInfo" },
                [vim.diagnostic.severity.HINT] = { "Hint", "LspDiagnosticsDefaultHint" },
            }
            local res = diag_to_format[diagnostic.severity]
            return string.format("(%s) ", res[1]), res[2]
        end,
    },
    severity_sort = true,
})

