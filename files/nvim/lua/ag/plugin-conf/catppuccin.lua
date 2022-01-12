local catp = require("catppuccin")

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
    },
})
catp.load()
