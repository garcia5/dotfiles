if vim.fn.executable("claude") == 1 then
    vim.pack.add({ "gh:coder/claudecode.nvim" })

    require("claudecode").setup({
        terminal = {
            provider = "none", -- use tmux/ghostty split instead of builtin terminal
        },
        diff_opts = {
            layout = "unified",
            open_in_new_tab = true,
        },
        keys = {
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer to claude", mode = "n" } },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to claude", mode = "v" } },
        },
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        callback = function()
            vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { desc = "Add file", buffer = true })
        end,
    })
end
