local lualine = require('lualine')
lualine.setup{
    theme = "auto",
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            {"filename", path = 1} -- file w/ relative path
        },
        lualine_c = {"branch", "diff"},
        lualine_x = {
            {'diagnostics', sources = {'nvim_lsp'}},
        },
        lualine_y = {"filetype"},
        lualine_z = {"location"},
    },
    options = {
        disabled_filetypes = {
            'term'
        },
        section_separators = {'', ''},
        component_separators = {'', ''}
    }
}
