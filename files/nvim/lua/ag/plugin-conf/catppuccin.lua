local catp = require("catppuccin")

vim.g.catppuccin_flavour = "mocha"
catp.setup({
    transparent_background = true,
    term_colors = true,
    styles = {
        comments = "italic",
        functions = "NONE",
        keywords = "NONE",
        strings = "italic",
        variables = "NONE",
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
        native_lsp = {
            enabled = true,
        },
        ts_rainbow = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
    },
})
catp.load()
