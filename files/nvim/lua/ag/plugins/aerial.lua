return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        {
            "<Leader>ou",
            "<cmd>AerialToggle!<CR>",
            desc = "Open code outline",
        },
    },
    opts = {
        backends = { "treesitter" },
        layout = {
            max_width = 40,
            min_width = 20,
        },
        close_automatic_events = { "switch_buffer" },
        manage_folds = false,
        link_folds_to_tree = false,
        link_tree_to_folds = true,
        treesitter = {
            update_delay = 100,
        },
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
            "Field",
            "Key",
            "Namespace",
            "Property",
        },
    },
}
