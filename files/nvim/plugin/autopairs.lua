vim.pack.add({ "gh:windwp/nvim-autopairs", "gh:windwp/nvim-ts-autotag" })

require("nvim-autopairs").setup({
    map_cr = false, -- we handle CR ourselves below
    check_ts = true, -- use treesitter
    map_bs = true,
})

-- Custom <CR> that dismisses the completion menu instead of accepting a match
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() ~= 0 then
        -- Dismiss popup first, then feed the autopairs CR
        local dismiss = vim.api.nvim_replace_termcodes("<C-e>", true, false, true)
        local cr = require("nvim-autopairs").autopairs_cr()
        -- autopairs_cr() already returns replaced termcodes, so concat directly
        vim.api.nvim_feedkeys(dismiss .. cr, "n", false)
    else
        vim.api.nvim_feedkeys(require("nvim-autopairs").autopairs_cr(), "n", false)
    end
end, { noremap = true, silent = true, desc = "CR: dismiss completion + autopairs" })

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on <.../
    },
})
