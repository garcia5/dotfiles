return {
    "sidebar-nvim/sidebar.nvim",
    config = function()
        require("sidebar-nvim").setup({
            ["git"] = {
                icon = "",
            },
            sections = { "datetime", "git" },
        })
    end,
}
