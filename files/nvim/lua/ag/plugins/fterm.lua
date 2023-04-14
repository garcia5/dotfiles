return {
    "numToStr/FTerm.nvim",
    config = function()
        -- display
        require("FTerm").setup({
            border = "rounded",
            blend = 10, -- a little transparent
        })

        -- basics
        vim.keymap.set("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>')
        vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

        -- build
        vim.api.nvim_create_user_command("PBuild", function()
            require("FTerm").scratch({ cmd = { "pnpm-build" } }) -- my own `pnpm build` alias
            vim.cmd("LspRestart")
        end, { bang = true })
        vim.keymap.set("n", "<Leader>pb", ":PBuild<CR>")

        -- test
        vim.api.nvim_create_user_command(
            "PTest",
            function() require("FTerm").run({ "pnpm", "test" }) end,
            { bang = true }
        )
        vim.keymap.set("n", "<Leader>pt", ":PTest<CR>")

        -- push
        vim.api.nvim_create_user_command(
            "GPush",
            function() require("FTerm").scratch({ cmd = { "gpush" } }) end, -- my own `git push` alias
            { bang = true }
        )
    end,
}
