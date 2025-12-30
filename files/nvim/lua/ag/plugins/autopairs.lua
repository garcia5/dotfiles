local autopairs = {
    "windwp/nvim-autopairs",
    opts = {
        map_cr = true, -- send closing symbol to its own line
        check_ts = true, -- use treesitter
    },
    event = "InsertEnter",
}

local autotag = {
    "windwp/nvim-ts-autotag",
    ft = {
        "html",
        "vue",
        "javascriptreact",
        "typescriptreact",
    },
}

return {
    autopairs,
    autotag,
}
