local lualine = require("lualine")

local IS_WIDE = function() return vim.o.columns > 150 end

lualine.setup({
    sections = {
        --+-------------------------------------------------+--
        --| A | B | C                             X | Y | Z |--
        --+-------------------------------------------------+--
        lualine_a = {
            {
                "mode",
                fmt = function(m) return IS_WIDE() and m or m:sub(1, 1) end,
            },
        },
        lualine_b = { "branch" },
        lualine_c = {
            {
                "diff",
                symbols = {
                    modified = "~",
                    removed = "-",
                    added = "+",
                },
            },
            -- add empty section to center filename
            {
                "%=",
                separator = "",
            },
            {
                "filename",
                path = 1, -- full file path, doesn't take up too much room b/c laststatus = 3
                color = { fg = "#ffffff", gui = "bold" },
                shorting_target = 30,
            },
        },
        lualine_x = {
            {
                function()
                    local msg = "No Active Lsp"
                    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then return msg end

                    local client_names = {}
                    local active_client = false
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            active_client = true
                            if not client_names[client.name] then client_names[client.name] = 1 end
                        end
                    end

                    if active_client then
                        local names = {}
                        for name, _ in pairs(client_names) do
                            table.insert(names, name)
                        end
                        return table.concat(names, ", ")
                    end

                    return "No Active Lsp"
                end,
                icon = " LSP:",
                color = { gui = "bold" },
                cond = IS_WIDE,
            },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
            },
        },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
    },
    tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                "aerial",
                sep = " ) ",
                depth = nil,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "tabs" },
    },
    options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        theme = "catppuccin",
        disabled_filetypes = { "aerial" },
        globalstatus = true,
    },
    extensions = {
        "aerial",
        "fugitive",
        "nvim-dap-ui",
        "nvim-tree",
        "quickfix",
    },
})
