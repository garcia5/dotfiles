local transparent = true

return {
    "catppuccin/nvim",
    name = "catppuccin",
    build = ":CatppuccinCompile",
    lazy = false,
    priority = 1000,
    enabled = true,
    opts = {
        transparent_background = transparent,
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
            lualine = {
                all = function(C)
                    local transparent_bg = transparent and "NONE" or C.mantle
                    return {
                        normal = {
                            a = { bg = C.blue, fg = C.mantle, gui = "bold" },
                            b = { bg = C.surface0, fg = C.blue },
                            c = { bg = transparent_bg, fg = C.text },
                        },

                        insert = {
                            a = { bg = C.green, fg = C.base, gui = "bold" },
                            b = { bg = C.surface0, fg = C.green },
                        },

                        terminal = {
                            a = { bg = C.green, fg = C.base, gui = "bold" },
                            b = { bg = C.surface0, fg = C.green },
                        },

                        command = {
                            a = { bg = C.peach, fg = C.base, gui = "bold" },
                            b = { bg = C.surface0, fg = C.peach },
                        },
                        visual = {
                            a = { bg = C.mauve, fg = C.base, gui = "bold" },
                            b = { bg = C.surface0, fg = C.mauve },
                        },
                        replace = {
                            a = { bg = C.red, fg = C.base, gui = "bold" },
                            b = { bg = C.surface0, fg = C.red },
                        },
                        inactive = {
                            a = { bg = transparent_bg, fg = C.blue },
                            b = { bg = transparent_bg, fg = C.surface1, gui = "bold" },
                            c = { bg = transparent_bg, fg = C.overlay0 },
                        },
                    }
                end,
            },
            nvimtree = true,
            render_markdown = true,
            semantic_tokens = true,
            treesitter = true,
            treesitter_context = true,
        },
    },
}
