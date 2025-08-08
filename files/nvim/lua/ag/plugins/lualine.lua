local IS_WIDE = function() return vim.o.columns > 150 end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "AndreM222/copilot-lualine",
    },
    opts = {
        sections = {
            --+-------------------------------------------------+--
            --| A | B | C                             X | Y | Z |--
            --+-------------------------------------------------+--
            lualine_a = {
                {
                    "mode",
                    fmt = function(m) return IS_WIDE() and m or m:sub(1, 1) end,
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
                -- add empty section to center filename
                {
                    "%=",
                },
                -- A hack to change the path type if the window gets too short. Lualine doesn't accept a function for the
                -- `path` option, so just swap out the entire component
                {
                    "filename",
                    path = 1, -- full file path
                    color = { fg = "#ffffff", gui = "bold" },
                    shorting_target = 30,
                    cond = IS_WIDE,
                },
                {
                    "filename",
                    path = 0, -- just the filename
                    color = { fg = "#ffffff", gui = "bold" },
                    shorting_target = 30,
                    cond = function() return not IS_WIDE() end,
                },
            },
            lualine_x = {
                {
                    "copilot",
                    show_colors = true,
                    show_status = true,
                    color = { gui = "bold" },
                    symbols = {
                        status = {
                            enabled = " ",
                            sleep = " ",
                            disabled = " ",
                            warning = " ",
                            unknown = " ",
                        },
                    },
                },
            },
            lualine_y = {
                {
                    "lsp_status",
                    icon = " LSP:",
                    color = { gui = "bold" },
                    cond = IS_WIDE,
                },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                },
            },
            lualine_z = {
                { "filetype" },
                { "location", cond = IS_WIDE },
                { "progress", cond = IS_WIDE },
            },
        },
        tabline = {
            lualine_a = {
                {
                    "buffers",
                    mode = 0, -- name only
                    max_length = vim.o.columns / 2,
                    use_mode_colors = true,
                },
            },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "tabs" },
        },
        options = {
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            theme = "catppuccin",
            globalstatus = true,
        },
        extensions = {
            "aerial",
            "fugitive",
            "lazy",
            "man",
            "quickfix",
        },
    },
}
