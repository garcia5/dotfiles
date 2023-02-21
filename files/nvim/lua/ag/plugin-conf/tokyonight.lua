return {
    "folke/tokyonight.nvim", -- the other lua colorscheme
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "night",
            transparent = false,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                strings = { italic = true },
            },
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
                -- borderless telescope
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
            end,
            sidebars = { "qf", "help", "aerial", "packer" },
        })
        vim.cmd([[colorscheme tokyonight]])
    end,
}
