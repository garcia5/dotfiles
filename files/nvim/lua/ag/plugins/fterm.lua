return {
    "numToStr/FTerm.nvim",
    keys = {
        { "<M-i>", function() require("FTerm").toggle() end, mode = { "n", "t", "i" }, desc = "toggle floatterm" },
        { "<Leader>tt", "<CMD>FTest<CR>", mode = "n", desc = "test current file" },
        { "<Leader>ta", "<CMD>FTest all<CR>", mode = "n", desc = "run test suite" },
    },
    cmd = {
        "FTest",
    },
    init = function()
        local get_pytest_prefix = function()
            local pytest = "pytest"
            local venv_cmd = require("ag.utils").command_in_virtual_env(pytest)
            if venv_cmd ~= nil then return venv_cmd end
            return pytest
        end

        local test_commands = {
            python = get_pytest_prefix,
        }

        vim.api.nvim_create_user_command("FTest", function(opts)
            local buf = vim.api.nvim_buf_get_name(0)
            local filetype = vim.filetype.match({ filename = buf })
            local runner = test_commands[filetype]
            local scratch_cmd = {}

            if vim.tbl_contains(opts["fargs"], "all") then
                scratch_cmd = { runner() }
            else
                scratch_cmd = { runner(), buf }
            end

            if runner ~= nil then require("FTerm").scratch({ cmd = scratch_cmd }) end
        end, { desc = "Test current file", nargs = "?" })
    end,
    opts = {
        cmd = { "/bin/zsh", "-l" },
    },
}
