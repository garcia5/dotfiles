vim.pack.add({ "gh:windwp/nvim-autopairs", "gh:windwp/nvim-ts-autotag" })

require("nvim-autopairs").setup({
    map_cr = true, -- send closing symbol to its own line
    check_ts = true, -- use treesitter
    map_bs = true,
})

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on <.../
    },
})
