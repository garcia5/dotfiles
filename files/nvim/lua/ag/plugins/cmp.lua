return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    enabled = false,
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
            matching = {
                disallow_fuzzy_matching = false,
                disallow_fullfuzzy_matching = false,
                disallow_partial_fuzzy_matching = false,
            },
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    -- https://github.com/lukas-reineke/cmp-under-comparator
                    function(entry1, entry2)
                        local _, entry1_under = entry1.completion_item.label:find("^_+")
                        local _, entry2_under = entry2.completion_item.label:find("^_+")
                        entry1_under = entry1_under or 0
                        entry2_under = entry2_under or 0
                        if entry1_under > entry2_under then
                            return false
                        elseif entry1_under < entry2_under then
                            return true
                        end
                    end,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                },
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
                    mode = "text_symbol",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    before = function(entry, vim_item)
                        vim_item.menu_hl_group = "Comment"

                        local source_names = {
                            luasnip = "snip",
                            nvim_lua = "nvim",
                            nvim_lsp = "lsp",
                            buffer = "buf",
                            nvim_lsp_signature_help = "param",
                        }
                        local source_name
                        if vim.tbl_contains(source_names, entry.source.name) then
                            source_name = source_names[entry.source.name]
                        else
                            source_name = entry.source.name
                        end
                        vim_item.menu = " " .. source_name .. ""

                        return vim_item
                    end,
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
