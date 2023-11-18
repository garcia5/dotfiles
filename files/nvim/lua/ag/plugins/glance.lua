return {
    "dnlhc/glance.nvim",
    config = function ()
        local glance = require("glance")
        local actions = glance.actions
        glance.setup({
            detached = function (winid)
                return vim.api.nvim_win_get_width(winid) < 100
            end,
            preview_win_opts = {
                wrap = false,
                number = true,
                cursorline = true,
            },
            border = {
                enable = true,
                top_char = '―',
                bottom_char = '―',
            },
            mappings = {
                list = {
                    ['<C-v>'] = actions.jump_vsplit,
                    ['<C-x>'] = actions.jump_split,
                }
            }
        })
    end,
    cmd = "Glance",
}
