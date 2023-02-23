return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
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
    },
}
