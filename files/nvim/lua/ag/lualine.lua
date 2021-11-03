local lualine = require('lualine')
local is_lualine_buf = function ()
    local cur_buftype = vim.opt.buftype:get()
    -- Don't load special status line things for these buffer types
    local disable_for_buftypes = {'terminal', 'help', 'quickfix', 'nofile'}

    for _, buftype in ipairs(disable_for_buftypes) do
        if buftype == cur_buftype then return false end
    end
    return true
end

lualine.setup({
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
    tabline = {
        lualine_a = {'buffers'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'tabs'}
    },
    options = {
        section_separators = { left = '', right = ''},
        component_separators = { left = '', right = ''},
        theme = "catppuccino",
    },
    extensions = {
        'quickfix',
        'fugitive',
        'nvim-tree',
    },
})
