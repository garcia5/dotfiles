local telescope = require('telescope')

local M = {}

M.builtin = function (builtin_func)
    local func = require('telescope.builtin')[builtin_func]
    local theme = require('telescope.themes').get_ivy()
    return func(theme)
end

telescope.setup{
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        layout_config = {
            width           = 0.75,
            prompt_position = "top",
            preview_cutoff  = 120,
        },
        prompt_prefix      = "» ",
        selection_strategy = "reset",
        sorting_strategy   = "ascending",
        layout_strategy    = "horizontal",
        path_display       = {"shorten"},
        winblend           = 0, -- transparency
        border             = {},
        borderchars        = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons     = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
    },
    pickers = {
        buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = {
                i = {
                    ["<c-d>"] = require("telescope.actions").delete_buffer,
                },
                n = {
                    ["<c-d>"] = require("telescope.actions").delete_buffer,
                },
            },
        },
    },
}

return M
