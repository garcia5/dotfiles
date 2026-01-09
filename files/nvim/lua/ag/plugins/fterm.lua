return {
    "numToStr/FTerm.nvim",
    keys = {
        { "<M-i>", function() require("FTerm").toggle() end, mode = { "n", "t", "i" }, desc = "toggle floatterm" },
        { "<Leader>tt", "<cmd>Ftest<cr>", mode = "n", desc = "test current file" },
        { "<Leader>ta", "<cmd>Ftest all<cr>", mode = "n", desc = "run test suite" },
    },
    cmd = {
        "Ftest",
    },
    init = function()
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
    end,
    opts = {
        cmd = { "/bin/zsh", "-l" },
    },
}
