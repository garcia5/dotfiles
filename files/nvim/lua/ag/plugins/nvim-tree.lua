return {
    "kyazdani42/nvim-tree.lua", -- no more netrw
    opts = {
        hijack_cursor = true,
        view = {
            adaptive_size = true,
            width = 30,
            side = "left",
        },
        git = {
            enable = true, -- show git statuses
            ignore = false, -- still show .gitignored files
        },
    },
    keys = {
        { "<Leader>nt", "<cmd>NvimTreeToggle<CR>",   desc = "toggle file browser" },
        { "<Leader>nf", "<cmd>NvimTreeFindFile<CR>", desc = "open file browser with current file showing" },
        { "<Leader>nr", "<cmd>NvimTreeRefresh<CR>",  desc = "refresh file browser" },
    },
}
