return {
    "catppuccin/nvim",
    name = "catppuccin",
    build = ":CatppuccinCompile",
    lazy = false,
    priority = 1000,
    enabled = true,
    opts = {
        transparent_background = true,
        flavour = "auto",
        term_colors = true,
        compile = {
            enabled = true,
            path = vim.fn.stdpath("cache") .. "/catppuccin",
        },
        background = {
            light = "latte",
            dark = "mocha",
        },
        styles = {
            comments = { "italic" },
        },
        custom_highlights = function(colors)
            return {
                -- More pronounced treesitter context background
                TreesitterContext = {
                    bg = colors.mantle,
                },
            }
        end,
        default_integrations = false,
        integrations = {
            aerial = true,
            alpha = true,
            blink_cmp = true,
            diffview = true,
            fzf = true,
            gitsigns = {
                enabled = true,
                transparent = true,
            },
            indent_blankline = {
                enabled = true,
                colored_indent_levels = true,
            },
            lsp_styles = {
                inlay_hints = {
                    background = false,
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
            },
            nvimtree = true,
            render_markdown = true,
            semantic_tokens = true,
            treesitter = true,
            treesitter_context = true,
        },
    },
}
