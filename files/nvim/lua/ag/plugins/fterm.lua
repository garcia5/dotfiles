return {
    "numToStr/FTerm.nvim",
    keys = {
        { "<M-i>", '<CMD>lua require("FTerm").toggle()<CR>', mode = "n", desc = "toggle floatterm" },
        { "<M-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', mode = "t", desc = "toggle floatterm" },
    },
    config = function()
        -- display
        require("FTerm").setup({
            border = "rounded",
            cmd = { "/bin/zsh", "-l" },
            blend = 10, -- a little transparent
        })
        -- push
        vim.api.nvim_create_user_command(
            "GPush",
            function() require("FTerm").scratch({ cmd = { "gpush" } }) end, -- my own `git push` alias
            { bang = true }
        )
    end,
}
