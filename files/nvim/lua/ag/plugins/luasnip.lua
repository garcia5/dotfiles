return {
    "L3MON4D3/LuaSnip", -- snippets
    name = "luasnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
        local ls = require("luasnip")
        local types = require("luasnip.util.types")
        local snippets = require("ag.snippets")

        ---#Config
        ls.setup({
            keep_roots = false,
            link_roots = false,
            link_children = false,
            -- Update snippet text in _real time_
            updateevents = { "TextChanged", "TextChangedI" },
            enable_autosnippets = true,
            delete_check_events = { "InsertLeave" },
            -- Show virtual text hints for node types
            ext_opts = {
                [types.insertNode] = {
                    active = {
                        virt_text = { { "●", "Operator" } },
                    },
                },
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "●", "Constant" } },
                    },
                },
            },
        })
        -- load vscode style snippets from other plugins
        require("luasnip.loaders.from_vscode").lazy_load()

        ---#Mappings
        -- Previous snippet region
        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            if ls.jumpable(-1) then ls.jump(-1) end
        end, { silent = true })

        -- Expand snippet, or go to next snippet region
        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            if ls.expand_or_jumpable() then ls.expand_or_jump() end
        end, { silent = true })

        -- Cycle "choices" for current snippet region
        vim.keymap.set({ "i", "s" }, "<C-l>", function()
            if ls.choice_active() then ls.change_choice(1) end
        end)

        -- load my custom snippets
        ls.add_snippets("typescript", snippets.typescript)
        ls.add_snippets("dart", snippets.dart)
        ls.add_snippets("python", snippets.python)
    end,
    ft = {
        "vue",
        "typescript",
        "javascript",
        "dart",
        "rust",
        "python",
    },
}
