return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        -- fzf filtering for telescope
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        "nvim-telescope/telescope-ui-select.nvim", -- Use telescope to override vim.ui.select
    },
    opts = {
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
            selection_caret = " ",
            multi_icon = "",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "flex", -- horiz on wide screen, vert on narrow screen
            path_display = { "smart" },
            dynamic_preview_title = true,
            border = true,
            color_devicons = true,
            set_env = {
                ["COLORTERM"] = "truecolor",
            },
            layout_config = {
                prompt_position = "bottom",
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
    },
    config = function(opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
    end,
    keys = {
        {
            "<Leader>ff",
            "<cmd>Telescope find_files<CR>",
            desc = "Find files",
        },
        {
            "<Leader>fb",
            "<cmd>Telescope buffers<CR>",
            desc = "Switch buffer",
        },
        {
            "<Leader>gg",
            "<cmd>Telescope live_grep<CR>",
            desc = "Grep",
        },
        {
            "<Leader>fl",
            "<cmd>Telescope current_buffer_fuzzy_find<CR>",
            desc = "Find in file",
        },
        {
            "<Leader>gc",
            "<cmd>Telescope git_branches<CR>",
            desc = "Checkout branches",
        },
        {
            "<Leader>gl",
            "<cmd>Telescope git_commits<CR>",
            desc = "Checkout commits",
        },
        {
            "<Leader>qf",
            function() require("telescope.builtin").quickfix(require("telescope.themes").get_ivy()) end,
            desc = "Jump to items in quickfix list",
        },
        {
            "<Leader>R",
            function() require("telescope.builtin").resume() end,
            desc = "Reopen previous telescope picker",
        },
    },
    cmd = {
        "Telescope",
    },
}
