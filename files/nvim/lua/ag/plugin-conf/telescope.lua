local telescope = require("telescope")

local M = {}

-- Lets me globally apply themes
M.builtin = function(builtin_func, opts)
    local func = require("telescope.builtin")[builtin_func]
    --local theme = require('telescope.themes').get_ivy()
    return func(opts)
end

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
        dash = {
            file_type_keywords = {
                python = { "django", "python3" },
                vue = { "vue", "typescript" },
                typescript = { "typescript", "nodejs" },
                lua = { "lua" },
                bash = { "bash" },
            },
        },
        fzf = {
            fuzzy = true, -- let me make typos in file names please
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
    },
})

telescope.load_extension("fzf")

return M
