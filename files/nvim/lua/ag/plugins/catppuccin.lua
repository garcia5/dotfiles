return {
    "catppuccin/nvim",
    name = "catppuccin",
    build = ":CatppuccinCompile",
    lazy = false,
    priority = 1000,
    enabled = true,
    opts = {
        transparent_background = false,
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
            gitsigns = true,
            native_lsp = {
                enabled = true,
                inlay_hints = {
                    background = false,
                },
                virtual_text = {},
                underlines = {
                    errors = { "underline" },
                },
            },
            nvimtree = {
                enabled = true,
                show_root = false,
            },
            render_markdown = true,
            semantic_tokens = true,
            telescope = {
                enabled = true,
                style = "nvchad",
            },
            treesitter = true,
            treesitter_context = true,
        },
    },
}
