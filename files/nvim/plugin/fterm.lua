vim.pack.add({ "gh:numToStr/FTerm.nvim" })

require("FTerm").setup({
    cmd = { "/bin/zsh", "-l" },
})

vim.keymap.set({ "n", "t", "i" }, "<M-i>", function() require("FTerm").toggle() end, { desc = "toggle floatterm" })
vim.keymap.set("n", "<Leader>tt", "<cmd>Ftest<cr>", { desc = "test current file" })
vim.keymap.set("n", "<Leader>ta", "<cmd>Ftest all<cr>", { desc = "run test suite" })

local test_commands = {
    python = function() return { vim.fn.exepath("pytest") } end,
    typescript = function() return { "yarn", "test", "--" } end,
}

vim.api.nvim_create_user_command("Ftest", function(opts)
    local buf = vim.api.nvim_buf_get_name(0)
    local filetype = vim.filetype.match({ filename = buf })
    local runner = test_commands[filetype]
    local scratch_cmd = {}

    if vim.tbl_contains(opts["fargs"], "all") then
        scratch_cmd = { runner() }
    else
        scratch_cmd = { runner(), buf }
    end
    scratch_cmd = vim.iter(scratch_cmd):flatten():totable()

    if runner ~= nil then require("FTerm").scratch({ cmd = scratch_cmd }) end
end, { desc = "Test current file", nargs = "?" })
