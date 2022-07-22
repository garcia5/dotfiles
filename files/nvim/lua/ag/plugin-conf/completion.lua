local cmp = require("cmp")
if not cmp then return end

cmp.setup({
    snippet = {
        expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
    },
    sources = {
        { name = "vsnip" },
        { name = "nvim_lua" },
        { name = "nvim_lsp", max_item_count = 30 }, -- tsserver likes to send back _everything_
        { name = "nvim_lsp_signature_help" },
        { name = "buffer", keyword_length = 3 }, -- don't complete from buffer right away
    },
    mapping = {
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-h>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true, -- use first result if none explicitly selected
        }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    preselect = cmp.PreselectMode.None,
    formatting = {
        -- Show where the completion opts are coming from
        format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
                vsnip = "[vsnip]",
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
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})
