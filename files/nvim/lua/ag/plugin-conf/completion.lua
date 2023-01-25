local cmp = require("cmp")
if not cmp then return end

cmp.setup({
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 }, -- don't complete from buffer right away
    }),
    mapping = cmp.mapping.preset.insert({
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-h>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true, -- use first result if none explicitly selected
        }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    }),
    preselect = cmp.PreselectMode.Item, -- auto select whatever entry the source says
    formatting = {
        -- Show where the completion opts are coming from
        format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
                luasnip = "[snippet]",
                nvim_lua = "[nvim]",
                nvim_lsp = "[LSP]",
                path = "[path]",
                buffer = "[buffer]",
                nvim_lsp_signature_help = "[param]",
            },
        }),
    },
    experimental = {
        native_menu = false,
        ghost_text = true,
    },
})
