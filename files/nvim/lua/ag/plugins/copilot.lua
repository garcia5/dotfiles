return {
    "zbirenbaum/copilot.lua",
    keys = {
        {
            "<C-.>",
            function () require("copilot").next() end,
            mode = "i",
            desc = "Next copilot suggestion",
        },
        {
            "<C-,>",
            function () require("copilot").next() end,
            mode = "i",
            desc = "Prev copilot suggestion",
        },
    },
    cmd = {
        "Copilot",
    },
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = false,
                keymap = {
                    accept = "<C-/>",
                    next = "<C-.>",
                    prev = "<C-,>",
                    dismiss = "<C-c>",
                },
            },
            panel = {
                enabled = true,
                keymap = {
                    jump_prev = "cp",
                    jump_next = "cn",
                    accept = "<CR>",
                    refresh = "gr",
                },
            },
            filetypes = {
                markdown = false,
                gitrebase = false,
                help = false,
                ["*"] = true,
            },
        })

        -- auto show/hide when cmp menu is active
        local cmp = require("cmp")
        cmp.event:on("menu_opened", function() vim.b.copilot_suggestion_hidden = true end)
        cmp.event:on("menu_closed", function() vim.b.copilot_suggestion_hidden = false end)
    end,
}
