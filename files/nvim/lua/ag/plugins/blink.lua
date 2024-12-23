return {
    "saghen/blink.cmp",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
        },
    },
    -- use a release tag to download pre-built binaries
    version = "v0.*",
    opts = {
        keymap = { preset = "default" },
        appearance = {
            nerd_font_variant = "mono",
        },

        sources = {
            completion = {
                enabled_providers = { "luasnip", "lsp", "path", "buffer" },
            },
            providers = {
                luasnip = {
                    name = "Luasnip",
                    module = "blink.cmp.sources.luasnip",
                    score_offset = 3,
                    opts = {
                        -- Whether to use show_condition for filtering snippets
                        use_show_condition = true,
                        -- Whether to show autosnippets in the completion list
                        show_autosnippets = true,
                    },
                },
            },
            -- default = { "luasnip", "lsp", "path", "buffer" },
        },

        completion = {
            menu = {
                border = "single",
            },
            documentation = {
                auto_show = true,
            },
        },

        -- experimental signature help support
        signature = { enabled = true },

        -- enable luasnip as snippet backend
        snippets = {
            expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
            active = function(filter)
                if filter and filter.direction then return require("luasnip").jumpable(filter.direction) end
                return require("luasnip").in_snippet()
            end,
            jump = function(direction) require("luasnip").jump(direction) end,
        },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
}
