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
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        callback = function()
            vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { desc = "Add file", buffer = true })
        end,
    })
    vim.keymap.set(
        "n",
        "<leader>ab",
        "<cmd>ClaudeCodeAdd %<CR>",
        { desc = "Send current buffer name to claude", silent = true }
    )
    vim.keymap.set(
        "v",
        "<leader>as",
        "<cmd>ClaudeCodeSend<CR>",
        { desc = "Send current selection to claude", silent = true }
    )
end
