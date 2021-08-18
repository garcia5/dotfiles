local lualine = require('lualine')
local is_lualine_buf = function ()
    local cur_buftype = vim.opt.buftype:get()
    -- Don't load special status line things for these buffer types
    local disable_for_buftypes = {'terminal', 'help', 'quickfix'}

    for _, buftype in ipairs(disable_for_buftypes) do
        if buftype == cur_buftype then return false end
    end
    return true
end

lualine.setup{
    theme = "nightfox",
    sections = {
        --+-------------------------------------------------+--
        --| A | B | C                             X | Y | Z |--
        --+-------------------------------------------------+--
        lualine_a = {"mode"},
        lualine_b = {"branch", {
            "filename",
            path = 1, -- relative path
            condition = is_lualine_buf,
        }},
        lualine_c = {{
            "diff",
            symbols = {
                modified = '',
                removed = '',
                added = '',
            },
            -- TODO: Read these values from the colorscheme __somehow__
            color_removed = '#ea6962',
            color_modified = '#7daea3',
            color_added = '#a9b665',
            condition = is_lualine_buf,
        }},
        lualine_x = {{
            'diagnostics',
            sources = {'nvim_lsp'},
            condition = is_lualine_buf,
        }},
        lualine_y = {"filetype"},
        lualine_z = {{
            "location",
            condition = is_lualine_buf,
        }},
    },
    options = {
        section_separators = {'', ''},
        component_separators = {'', ''},
    }
}
