vim.pack.add({ "gh:ibhagwan/fzf-lua", "gh:nvim-tree/nvim-web-devicons" })

vim.env.FZF_DEFAULT_OPTS = nil -- clear fzf setup from terminal
require("fzf-lua").setup({
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
})
vim.keymap.set("n", "<Leader>ff", "<cmd>FzfLua files<CR>", { desc = "Fuzzy find files" })
vim.keymap.set("n", "<Leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Fuzzy find open buffers" })
vim.keymap.set("n", "<Leader>gg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<Leader>fl", "<cmd>FzfLua lines<CR>", { desc = "Fuzzy find lines" })
vim.keymap.set("n", "<Leader>R", "<cmd>FzfLua resume<CR>", { desc = "Resume last fuzzy picker" })
