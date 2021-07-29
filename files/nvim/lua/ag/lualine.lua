local lualine = require('lualine')
lualine.setup{
    theme = "auto",
    sections = {
        lualine_a = {"mode"},
        lualine_b = {"filename"},
        lualine_c = {"branch", "diff"},
        lualine_x = {
            {'diagnostics', sources = {'nvim_lsp'}},
        },
        lualine_y = {"filetype"},
        lualine_z = {"location"},
    },
}
