return {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
        },
    },
    -- use a release tag to download pre-built binaries
    version = "v0.*",
    opts = {
        -- disable for special buffers
        enabled = function() return not vim.tbl_contains({ "snacks_picker_input", "copilot-chat" }, vim.bo.filetype) end,

        -- For the most part keep default keymaps, but trigger with <C-h> instead of <C-space>
        keymap = {
            preset = "default",
            ["<C-h>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<C-y>"] = { "select_and_accept", "fallback" },

            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },

            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },

        appearance = {
            nerd_font_variant = "mono",
        },

        sources = {
            default = { "snippets", "lsp", "path", "buffer" },
            per_filetype = { yaml = { "path", "buffer" } },
            min_keyword_length = 0,
            providers = {
                markdown = {
                    name = "RenderMarkdown",
                    module = "render-markdown.integ.blink",
                    fallbacks = { "lsp" },
                },
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    fallbacks = { "buffer" },
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    fallbacks = { "buffer" },
                    opts = {
                        -- complete path from vim CWD rather than buffer directory
                        get_cwd = function(_) return vim.fn.getcwd() end,
                    },
                },
            },
        },

        cmdline = {
            enabled = false,
        },

        completion = {
            -- disable automatically adding brackets on accept: really annoying for adding imports
            accept = { auto_brackets = { enabled = false } },

            documentation = {
                -- show documentation popup by default
                auto_show = true,
            },

            -- show ghost text of top completion item
            ghost_text = { enabled = false },

            -- use entire word under cursor for completion, not just the part before the cursor
            keyword = { range = "full" },

            list = {
                -- Limit number of results shown in menu
                max_items = 25,
                -- allow cycling on either end of the list
                cycle = {
                    from_bottom = true,
                    from_top = true,
                },
                selection = {
                    preselect = false,
                    auto_insert = true,
                },
            },

            menu = {
                -- Show completion menu by default
                auto_show = true,
                -- menu looks more like nvim-cmp
                border = "single",
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                },
            },
        },

        -- Enable experimental signature help support
        signature = {
            enabled = true,
            window = {
                border = "single",
            },
        },

        -- enable luasnip as snippet backend
        snippets = {
            preset = "luasnip",
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
