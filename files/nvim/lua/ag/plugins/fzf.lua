return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        fzf_opts = {
            ["--info"] = "inline-right",
            ["--scrollbar"] = "▏▕",
            ["--reverse"] = true,
            ["--multi"] = true,
            ["--pointer"] = "",
            ["--marker"] = "",
            ["--ghost"] = "Search",
        },
    },
    init = function()
        -- clear fancy terminal FZF setup, simplify for nvim
        vim.env.FZF_DEFAULT_OPTS = nil
    end,
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
