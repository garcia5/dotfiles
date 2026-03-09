-- Provides neovim "ide" integration with claude code cli

return {
    "coder/claudecode.nvim",
    enabled = function() return vim.fn.executable("claude") ~= 1 end,
    event = "VeryLazy",
    opts = {
        terminal = {
            provider = "none", -- use tmux split instead of builtin terminal
        },
    },
    keys = {
        -- { "<leader>a", nil, desc = "AI/Claude Code" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
        {
            "<leader>as",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        },
        -- Diff management
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
}
