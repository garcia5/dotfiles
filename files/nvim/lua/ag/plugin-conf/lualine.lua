local lualine = require("lualine")
local is_lualine_buf = function()
    return vim.opt.buftype:get() ~= "terminal"
end

lualine.setup({
    sections = {
        --+-------------------------------------------------+--
        --| A | B | C                             X | Y | Z |--
        --+-------------------------------------------------+--
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
            {
                "filename",
                path = 0, -- just file name
                cond = is_lualine_buf,
            },
            {
                "diff",
                symbols = {
                    modified = "~",
                    removed = "-",
                    added = "+",
                },
                cond = is_lualine_buf,
            },
        },
        lualine_x = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                cond = is_lualine_buf,
            },
        },
        lualine_y = { "filetype" },
        lualine_z = {
            {
                "location",
                cond = is_lualine_buf,
            },
        },
    },
    tabline = {
        lualine_a = {
            {
                "buffers",
                max_length = vim.o.columns / 2, -- take up at most 1/2 of the window
            },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
            {
                "aerial",
                sep = " ) ",
                depth = nil,
                cond = is_lualine_buf,
            },
        },
        lualine_y = {},
        lualine_z = { "tabs" },
    },
    options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        theme = "catppuccin",
        disabled_filetypes = { "aerial", "TelescopePrompt", "help" },
    },
    extensions = {
        "aerial",
        "quickfix",
        "fugitive",
        "nvim-tree",
    },
})
