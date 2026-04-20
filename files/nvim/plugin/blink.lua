vim.pack.add({
    { src = "gh:saghen/blink.cmp", version = vim.version.range("v1.*") },
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*gemini-edit*", "*/.gemini/tmp/*", "*claude-*", "*claudecode*" },
    callback = function() vim.opt_local.iskeyword:append(".") end,
})

require("blink.cmp").setup({
    -- disable for special buffers, but FORCE enable for ai prompt buffers
    enabled = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if
            bufname:match("gemini%-edit")
            or bufname:match("%.gemini/tmp/")
            or bufname:match("claude%-")
            or bufname:match("claudecode")
        then
            return "force"
        end
        return not vim.tbl_contains({ "snacks_picker_input", "copilot-chat" }, vim.bo.filetype)
    end,

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
        default = function()
            return { "snippets", "lsp", "path", "buffer", "files" }
        end,
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
            files = {
                name = "Files",
                module = "ag.sources.files",
                score_offset = 100,
                async = true,
            },
        },
    },

    cmdline = {
        enabled = false,
    },

    completion = {
        accept = { auto_brackets = { enabled = false } },
        documentation = { auto_show = true },
        ghost_text = { enabled = false },
        keyword = { range = "full" },
        list = {
            max_items = 25,
            cycle = { from_bottom = true, from_top = true },
            selection = { preselect = false, auto_insert = true },
        },
        menu = {
            auto_show = true,
            draw = {
                columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            },
        },
    },

    fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = { "score", "sort_text", "exact" },
    },

    signature = { enabled = true },
})
