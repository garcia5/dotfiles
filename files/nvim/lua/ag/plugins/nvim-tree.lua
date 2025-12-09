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
        on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            -- use default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            vim.keymap.set(
                "n",
                "<C-s>",
                api.node.open.horizontal,
                { silent = true, buffer = bufnr, noremap = true, desc = "Open: Horizontal split" }
            )
        end,
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
