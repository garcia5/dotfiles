return {
    "numToStr/FTerm.nvim",
    keys = {
        { "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>', mode = "n", desc = "toggle floatterm" },
        { "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', mode = "t", desc = "toggle floatterm" },
        { "<Leader>pb", ":PBuild<CR>", desc = "pnpm build" },
        { "<Leader>pt", ":PTest<CR>", desc = "pnpm test" },
    },
    config = function()
        -- display
        require("FTerm").setup({
            border = "rounded",
            blend = 10, -- a little transparent
        })

        -- build
        vim.api.nvim_create_user_command("PBuild", function()
            require("FTerm").scratch({ cmd = { "pnpm", "build" } })
            vim.cmd("LspRestart")
        end, { bang = true })

        -- test
        vim.api.nvim_create_user_command(
            "PTest",
            function() require("FTerm").run({ "pnpm", "test" }) end,
            { bang = true }
        )

        -- push
        vim.api.nvim_create_user_command(
            "GPush",
            function() require("FTerm").scratch({ cmd = { "gpush" } }) end, -- my own `git push` alias
            { bang = true }
        )
    end,
}
