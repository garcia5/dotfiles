local catp = require("catppuccin")

if vim.g.colors_name == "catppuccin" then
    vim.g.catppuccin_flavour = "mocha"
    catp.setup({
        transparent_background = false,
        term_colors = true,
        compile = {
            enabled = true,
            path = vim.fn.stdpath("cache") .. "/catppuccin",
        },
        styles = {
            comments = { "italic" },
            strings = { "italic" },
        },
        integrations = {
            gitsigns = true,
            telescope = true,
            treesitter = true,
            cmp = true,
            nvimtree = {
                enabled = true,
                show_root = false,
            },
            dap = {
                enabled = true,
                enable_ui = true,
            },
            native_lsp = {
                enabled = true,
            },
            ts_rainbow = true,
            indent_blankline = {
                enabled = false,
                colored_indent_levels = false,
            },
        },
    })
end
