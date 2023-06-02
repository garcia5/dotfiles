return {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
        vim.g.catppuccin_flavour = "mocha"
        require("catppuccin").setup({
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
            custom_highlights = function(colors)
                local prompt = colors.surface0
                -- borderless telescope
                return {
                    TelescopeNormal = {
                        bg = colors.mantle,
                        fg = colors.text,
                    },
                    TelescopeBorder = {
                        bg = colors.mantle,
                        fg = colors.mantle,
                    },
                    TelescopePromptNormal = {
                        bg = prompt,
                    },
                    TelescopePromptBorder = {
                        bg = prompt,
                        fg = prompt,
                    },
                    TelescopePromptTitle = {
                        bg = prompt,
                        fg = prompt,
                    },
                    TelescopePreviewTitle = {
                        bg = colors.mantle,
                        fg = colors.mantle,
                    },
                    TelescopeResultsTitle = {
                        bg = colors.mantle,
                        fg = colors.mantle,
                    },
                }
            end,
            integrations = {
                alpha = true,
                aerial = true,
                markdown = true,
                gitsigns = true,
                telescope = false, -- custom overrides for borderless
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
                ts_rainbow2 = true,
                indent_blankline = {
                    enabled = false,
                    colored_indent_levels = false,
                },
            },
        })
    end,
    build = ":CatppuccinCompile",
    priority = 1000,
    enabled = true,
}
