return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        disable_netrw = true,
        view = {
            signcolumn = "auto",
            width = {
                min = 30,
                max = "20%",
            },
        },
        renderer = {
            special_files = {
                "Makefile",
                "README.md",
                "CONTRIBUTING.md",
                "package.json",
                "pyproject.toml",
            },
        },
        diagnostics = {
            enable = false,
        },
        filters = {
            custom = {
                "^\\.git", -- always hide .git/ dir
            },
        },
    },
    keys = {
        {
            "<Leader>nt",
            "<cmd>NvimTreeToggle<CR>",
            mode = { "n" },
            desc = "toggle NvimTree",
            silent = true,
        },
        {
            "<Leader>nf",
            ":NvimTreeFindFile<CR>",
            mode = { "n" },
            desc = "find current file in NvimTree",
            silent = true,
        },
    },
}
