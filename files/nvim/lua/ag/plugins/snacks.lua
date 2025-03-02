return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        explorer = {
            enabled = true,
        },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        picker = {
            enabled = true,
            prompt = "» ",
            matcher = { fuzzy = true, smartcase = true, ignorecase = true, frecency = false },
            ui_select = true,
            formatters = {
                file = {
                    filename_first = false, -- display filename before the file path
                    truncate = 40, -- truncate the file path to (roughly) this length
                    filename_only = false, -- only show the filename
                    icon_width = 2, -- width of the icon (in characters)
                    git_status_hl = true, -- use the git status highlight group for the filename
                },
            },
        },
        statuscolumn = {
            enabled = true,
        },
    },
    keys = {
        -- pickers
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Fuzzy find buffers" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Fuzzy find Files" },
        { "<leader>gg", function() Snacks.picker.grep() end, desc = "Live grep" },
        { "<leader>qf", function() Snacks.picker.qflist() end, desc = "Fuzzy find in qflist" },
        { "<leader>fl", function() Snacks.picker.lines() end, desc = "Fuzzy find in file" },
        -- explorer (also a picker)
        { "<leader>nt", function() Snacks.explorer.open() end, desc = "Open filetree" },
        { "<leader>nf", function() Snacks.explorer.reveal() end, desc = "Open current file in filetree" },
    },
}
