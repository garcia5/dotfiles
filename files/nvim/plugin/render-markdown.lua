vim.pack.add({
    "gh:MeanderingProgrammer/render-markdown.nvim",
    "gh:nvim-treesitter/nvim-treesitter",
})

require("render-markdown").setup({
    file_types = {
        "markdown",
        "copilot-chat",
    },
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
        backgrounds = { "", "", "", "", "", "" },
    },
    code = {
        style = "full",
        width = "block",
        border = "thin",
        position = "right",
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
                    style = "normal",
                    width = "full",
                },
            },
        },
    },
})
