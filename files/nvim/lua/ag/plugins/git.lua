local fugitive = {
    "tpope/vim-fugitive",
    dependencies = {
        "tpope/vim-rhubarb",
    },
    init = function()
        local ent_url = vim.fn.environ()["GH_ENTERPRISE_URL"]
        if ent_url ~= nil then
            vim.g.github_enterprise_urls = {
                [ent_url] = "https://" .. ent_url,
            }
        end
    end,
    keys = {
        {
            "<Leader>gs",
            ":tab Git<CR>",
            desc = "Git status in new tab",
        },
        {
            "<Leader>gx",
            ":GBrowse<CR>",
            desc = "Open current file in GitHub",
        },
    },
    cmd = "Git",
}

local gitsigns = {
    "lewis6991/gitsigns.nvim",
    opts = {
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
    },
}

local diffview = {
    "sindrets/diffview.nvim",
    keys = {
        {
            "<Leader>gd",
            "<cmd>DiffviewOpen<CR>",
            desc = "Open changed files",
        },
    },
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
    },
    opts = {
        enhanced_diff_hl = true,
        view = {
            merge_tool = {
                layout = "diff3_mixed",
            },
        },
    },
}

local vscode_diff = {
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        keymaps = {
            view = {
                next_file = "<Tab>",
                prev_file = "<S-Tab>",
            },
        },
    },
    cmd = {
        "CodeDiff",
    },
    keys = {
        {
            "<Leader>gd",
            "<cmd>CodeDiff<CR>",
            desc = "Open diffview",
        },
    },
}

return {
    fugitive,
    gitsigns,
    diffview,
    -- vscode_diff,
}
