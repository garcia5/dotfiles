vim.pack.add({
    "gh:tpope/vim-fugitive",
    "gh:tpope/vim-rhubarb",
    "gh:lewis6991/gitsigns.nvim",
    "gh:sindrets/diffview.nvim",
})

-- Fugitive
local ent_url = vim.fn.environ()["GH_ENTERPRISE_URL"]
if ent_url ~= nil then
    vim.g.github_enterprise_urls = {
        [ent_url] = "https://" .. ent_url,
    }
end
vim.api.nvim_create_user_command("Gwipe", function(_)
    vim.cmd("Git reset --hard")
    vim.cmd("Git clean --force -df")
end, { desc = "Reset fully to working tree" })

vim.keymap.set("n", "<Leader>gs", ":tab Git<CR>", { desc = "Git status in new tab" })
vim.keymap.set("n", "<Leader>gx", ":GBrowse<CR>", { desc = "Open current file in GitHub" })

-- Gitsigns
require("gitsigns").setup({
    preview_config = {
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
    signcolumn = true,
    numhl = true,
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
    },
    on_attach = function(bufnr)
        local keymap_opts = { silent = true, noremap = true, buffer = bufnr }
        vim.keymap.set(
            "n",
            "=",
            "<cmd>Gitsigns preview_hunk<CR>",
            vim.tbl_extend("force", keymap_opts, { desc = "Gitsigns float preview" })
        )
        vim.keymap.set(
            "n",
            "<Leader>rh",
            "<cmd>Gitsigns reset_hunk<CR>",
            vim.tbl_extend("force", keymap_opts, { desc = "Gitsigns float preview" })
        )
        vim.keymap.set(
            "n",
            "<Leader>sh",
            "<cmd>Gitsigns stage_hunk<CR>",
            vim.tbl_extend("force", keymap_opts, { desc = "Gitsigns stage" })
        )
        vim.keymap.set(
            "n",
            "<Leader>gn",
            function()
                require("gitsigns").nav_hunk(
                    "next",
                    { wrap = true, navigation_message = true, foldopen = false, preview = false }
                )
            end,
            vim.tbl_extend("force", keymap_opts, { desc = "Gitsigns goto next" })
        )
        vim.keymap.set(
            "n",
            "<Leader>gp",
            function()
                require("gitsigns").nav_hunk(
                    "prev",
                    { wrap = true, navigation_message = true, foldopen = false, preview = false }
                )
            end,
            vim.tbl_extend("force", keymap_opts, { desc = "Gitsigns goto prev" })
        )
        vim.keymap.set(
            "n",
            "<Leader>U",
            function() require("gitsigns").undo_stage_hunk() end,
            vim.tbl_extend("force", keymap_opts, { desc = "Undo last stage hunk" })
        )
    end,
})

-- Diffview
require("diffview").setup({
    enhanced_diff_hl = true,
    view = {
        merge_tool = {
            layout = "diff3_mixed",
        },
    },
})
vim.keymap.set("n", "<Leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open changed files" })
vim.keymap.set("n", "<Leader>gR", "<cmd>DiffviewRefresh<CR>", { desc = "Refresh diff view" })
