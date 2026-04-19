vim.pack.add({
    { src = "gh:saghen/blink.cmp", version = vim.version.range("v1.*") },
})

require("blink.cmp").setup({
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
            },
            snippets = {},
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
            draw = {
                columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            },
        },
    },

    -- enable fuzzy matching
    fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = {
            "exact",
            "score",
            "sort_text",
        },
    },

    -- Enable experimental signature help support
    signature = {
        enabled = true,
    },
})
