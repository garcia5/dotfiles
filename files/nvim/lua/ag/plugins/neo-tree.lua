return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    enabled = false,
    lazy = false, -- neo-tree will lazily load itself
    opts = {
        window = {
            mappings = {
                ["<C-v>"] = "open_vsplit",
                ["<C-s>"] = "open_split",
            }
        }
    },
    init = function ()
        vim.keymap.set("n", "<leader>nt", "<cmd>Neotree toggle<CR>", {silent = true, desc = "Open file tree"})
        vim.keymap.set("n", "<leader>nf", "<cmd>Neotree reveal<CR>", {silent = true, desc = "Open current file in file tree"})
    end
}
