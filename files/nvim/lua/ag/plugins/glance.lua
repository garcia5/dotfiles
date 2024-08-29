return {
    "dnlhc/glance.nvim",
    opts = {
        detached = function(winid) return vim.api.nvim_win_get_width(winid) < 100 end,
        preview_win_opts = {
            wrap = false,
            number = true,
            cursorline = true,
        },
        border = {
            enable = true,
            top_char = "―",
            bottom_char = "―",
        },
        mappings = {
            list = {
                ["<C-v>"] = function() require("glance").actions.jump_vsplit() end,
                ["<C-x>"] = function() require("glance").actions.jump_split() end,
            },
        },
    },
    cmd = "Glance",
}
