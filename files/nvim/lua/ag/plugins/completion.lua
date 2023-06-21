return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- completion sources
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-path",
        -- complements
        "onsails/lspkind-nvim", -- add the nice source + completion item kind to the menu
    },
    config = function()
        local cmp = require("cmp")
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
            mapping = {
                ["<C-u>"] = cmp.mapping.scroll_docs(-2),
                ["<C-d>"] = cmp.mapping.scroll_docs(2),
                ["<C-h>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-y>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true, -- use first result if none explicitly selected
                }),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            },
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
            performance = {
                max_view_entries = 50,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            experimental = {
                ghost_text = true,
            },
        })
    end,
}
