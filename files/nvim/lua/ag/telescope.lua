local telescope = require('telescope')

local M = {}

-- Lets me globally apply themes
M.builtin = function (builtin_func)
    local func = require('telescope.builtin')[builtin_func]
    --local theme = require('telescope.themes').get_ivy()
    return func()
end

telescope.setup({
    defaults = {
        vimgrep_arguments      = {
            'rg',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix          = "» ",
        selection_caret        = " ",
        selection_strategy     = "reset",
        sorting_strategy       = "ascending",
        layout_strategy        = "horizontal",
        path_display           = {"smart"},
        dynamic_preview_title  = true,
        border                 = true,
        borderchars            = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons         = true,
        set_env                = {
            ['COLORTERM'] = 'truecolor'
        },
        layout_config          = {
            prompt_position = "top",
            height          = 0.8,
        },
    },
    pickers = {
        buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = {
                i = {
                    ["<c-d>"] = "delete_buffer",
                },
                n = {
                    ["<c-d>"] = "delete_buffer",
                },
            },
        },
        live_grep = {
            mappings = {
                i = {
                    ["<c-l>"] = "smart_add_to_qflist"
                },
            },
        },
    },
})

return M
