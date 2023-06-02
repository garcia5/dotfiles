return {
    "anuvyklack/hydra.nvim",
    dependencies = {
        "tpope/vim-fugitive",
        "lewis6991/gitsigns.nvim",
        "sidebar-nvim/sidebar.nvim",
    },
    keys = {
        "<Leader>G",
        "<Leader>D",
        "<C-w>",
    },
    config = function()
        local Hydra = require("hydra")
        local modes = require("ag.hydra_modes")
        Hydra(modes.git())
        Hydra(modes.window_resize())
        Hydra(modes.debug())
    end,
}
