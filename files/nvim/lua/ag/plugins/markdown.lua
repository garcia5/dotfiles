return {
    "MeanderingProgrammer/render-markdown.nvim",
    as = "render-markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    ft = {
        "markdown",
    },
    main = "render-markdown",
    opts = {
        latex = {
            enabled = false,
        },
        anti_conceal = {
            enabled = true,
        },
        heading = {
            position = "overlay",
            border = true,
            above = "",
            below = "▔",
            width = "block",
            -- no background highlight for headings
            backgrounds = {
                "",
                "",
                "",
                "",
                "",
                "",
            },
        },
        code = {
            style = "full", -- show language highlights and name in code blocks
            width = "block",
            right_pad = 2,
        },
        link = {
            custom = {
                github = {
                    pattern = "^http[s]?://[%w%.%-]*github[%w%.%-]*%.com",
                    icon = " ",
                    highlight = "RenderMarkdownTableLink",
                },
                docs = {
                    pattern = "^http[s]?://docs.google.com",
                    icon = "󰈙 ",
                    highlight = "RenderMarkdownTableLink",
                },
            },
        },
        overrides = {
            buftype = {
                nofile = {
                    code = {
                        style = "normal", -- no language info in LSP hover windows
                        width = "full",
                    },
                },
            },
        },
    },
}
