return {
    "catppuccin/nvim",
    name = "catppuccin",
    build = ":CatppuccinCompile",
    lazy = false,
    priority = 1000,
    enabled = true,
    config = function()
        vim.g.catppuccin_flavour = "mocha"
        require("catppuccin").setup({
            transparent_background = true,
            term_colors = true,
            compile = {
                enabled = true,
                path = vim.fn.stdpath("cache") .. "/catppuccin",
            },
            styles = {
                comments = { "italic" },
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
                    -- treesitter context
                    TreesitterContext = {
                        bg = colors.mantle,
                    }
                }
            end,
            default_integrations = false,
            integrations = {
                aerial = true,
                alpha = true,
                gitsigns = true,
                markdown = true,
                cmp = true,
                native_lsp = {
                    enabled = true,
                    inlay_hints = {
                        background = false,
                    },
                    virtual_text = {},
                    underlines = {},
                },
                semantic_tokens = true,
                nvimtree = {
                    enabled = true,
                    show_root = false,
                },
                treesitter = true,
                treesitter_context = true,
                ts_rainbow2 = true,
            },
        })
    end,
}
