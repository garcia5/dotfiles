vim.pack.add({ "gh:windwp/nvim-autopairs", "gh:windwp/nvim-ts-autotag" })

require("nvim-autopairs").setup({
    map_cr = false, -- we handle CR ourselves below
    check_ts = true, -- use treesitter
    map_bs = true,
})

-- Custom <CR> that dismisses the completion menu instead of accepting a match
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() ~= 0 then
        return vim.api.nvim_replace_termcodes("<C-e>", true, false, true) .. require("nvim-autopairs").autopairs_cr()
    end
    return require("nvim-autopairs").autopairs_cr()
end, { expr = true, noremap = true, silent = true, desc = "CR: dismiss completion + autopairs" })

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on <.../
    },
})
