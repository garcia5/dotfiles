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
    opts = {
        opts = {
            enable_close = true, -- Auto close tags
            enable_rename = true, -- Auto rename pairs of tags
            enable_close_on_slash = true, -- Auto close on <.../
        },
    },
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
