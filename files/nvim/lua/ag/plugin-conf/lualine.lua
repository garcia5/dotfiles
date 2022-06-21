local lualine = require("lualine")

lualine.setup({
    sections = {
        --+-------------------------------------------------+--
        --| A | B | C                             X | Y | Z |--
        --+-------------------------------------------------+--
        lualine_a = {
            {
                "mode",
                fmt = function(m)
                    return m:sub(1, 1)
                end,
            },
        },
        lualine_b = { "branch" },
        lualine_c = {
            {
                "diff",
                symbols = {
                    modified = "~",
                    removed = "-",
                    added = "+",
                },
            },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
            },
            -- add empty section to center filename
            {
                "%=",
                separator = "",
            },
            {
                "filename",
                path = 1, -- full file path, doesn't take up too much room b/c laststatus = 3
                color = { gui = "bold" },
            },
        },
        lualine_x = {},
        lualine_y = { "filetype" },
        lualine_z = { "location" },
    },
    tabline = {
        lualine_a = {
            {
                function()
                    return vim.fn.getcwd()
                end,
                icon = "",
            },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
            {
                "aerial",
                sep = " ) ",
                depth = nil,
            },
        },
        lualine_y = {},
        lualine_z = { "tabs" },
    },
    options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        theme = "catppuccin",
        disabled_filetypes = { "aerial" },
        globalstatus = true,
    },
    extensions = {
        "aerial",
        "fugitive",
        "nvim-dap-ui",
        "nvim-tree",
        "quickfix",
    },
})
