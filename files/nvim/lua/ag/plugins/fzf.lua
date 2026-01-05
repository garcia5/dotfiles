return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        "borderless-full",
        fzf_opts = {
            ["--info"] = "inline-right",
            ["--scrollbar"] = "▏▕",
            ["--reverse"] = true,
            ["--multi"] = true,
            ["--pointer"] = "",
            ["--marker"] = "",
            ["--ghost"] = "Search",
        },
        ui_select = {
            winopts = {
                -- disable preview window for ui-select
                preview = {
                    hidden = true,
                },
                -- render UI select window centered at the top of the screen
                row = 2,
                col = 0.5,
                -- make the window smaller
                height = 0.2,
                width = 0.4,
            },
        },
    },
    init = function()
        -- clear terminal FZF setup, simplify for nvim
        vim.env.FZF_DEFAULT_OPTS = nil
    end,
    cmd = {
        "FzfLua",
    },
    keys = {
        {
            "<Leader>ff",
            "<cmd>FzfLua files<CR>",
            desc = "Fuzzy find files",
        },
        {
            "<Leader>fb",
            "<cmd>FzfLua buffers<CR>",
            desc = "Fuzzy find open buffers",
        },
        {
            "<Leader>gg",
            "<cmd>FzfLua live_grep<CR>",
            desc = "Live grep",
        },
        {
            "<Leader>fl",
            "<cmd>FzfLua lines<CR>",
            desc = "Fuzzy find lines",
        },
        {
            "<Leader>R",
            "<cmd>FzfLua resume<CR>",
            desc = "Resume last fuzzy picker",
        },
    },
}
