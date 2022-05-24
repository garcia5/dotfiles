local telescope = require("telescope")

telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--vimgrep",
        },
        file_ignore_patterns = {
            "%.png",
        },
        prompt_prefix = "» ",
        selection_caret = " ",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        path_display = { "smart" },
        dynamic_preview_title = true,
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = {
            ["COLORTERM"] = "truecolor",
        },
        layout_config = {
            prompt_position = "top",
            height = 0.8,
        },
    },
    pickers = {
        buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = {
                i = {
                    ["<c-d>"] = "delete_buffer", -- this overrides the built in preview scroller
                    ["<c-b>"] = "preview_scrolling_down",
                },
                n = {
                    ["<c-d>"] = "delete_buffer", -- this overrides the built in preview scroller
                    ["<c-b>"] = "preview_scrolling_down",
                },
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- let me make typos in file names please
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        ["ui-select"] = {
            require("telescope.themes").get_cursor(),
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("dap")
telescope.load_extension("ui-select")
