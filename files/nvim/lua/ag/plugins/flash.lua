return {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        { "R", function() require("flash").treesitter_search() end, mode = {"o", "x"}, desc = "Treesitter Search" },
    },
    opts = {
        search = {
            wrap = true, -- search whole buffer
            mode = "fuzzy", -- Other options: "exact" | "search"
            incremental = true, -- `incsearch`
        },
        jump = {
            nohlsearch = true, -- clear highlight after jump
        },
        label = {
            style = "eol", -- show jump label at EOL. Other options: "overlay" | "right_align" | "inline"
            -- highlight labels
            rainbow = {
                enabled = true,
                shade = 1,
            },
        },
        modes = {
            char = {
                enabled = false,
            },
        },
    },
}
