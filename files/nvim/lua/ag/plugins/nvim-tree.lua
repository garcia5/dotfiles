return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        disable_netrw = true,
        view = {
            signcolumn = "auto",
            width = {
                min = 30,
                max = "20%",
            },
        },
        renderer = {
            special_files = {
                "Makefile",
                "README.md",
                "CONTRIBUTING.md",
                "package.json",
                "pyproject.toml",
            },
        },
        diagnostics = {
            enable = false,
        },
        filters = {
            custom = {
                "^\\.git", -- always hide .git/ dir
            },
        },
        on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            -- use default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            vim.keymap.set(
                "n",
                "<C-s>",
                api.node.open.horizontal,
                { silent = true, buffer = bufnr, noremap = true, desc = "Open: Horizontal split" }
            )
            -- always show cursorline
            vim.opt_local.cursorline = true
        end,
    },
    init = function()
        -- autocmds
        local nvim_tree_group = vim.api.nvim_create_augroup("NvimTree", { clear = true })
        vim.api.nvim_create_autocmd("QuitPre", {
            group = nvim_tree_group,
            desc = "Quit nvim when nvim-tree is last window",
            callback = function()
                local invalid_win = {}
                local wins = vim.api.nvim_list_wins()
                for _, w in ipairs(wins) do
                    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                    if bufname:match("NvimTree_") ~= nil then table.insert(invalid_win, w) end
                end
                if #invalid_win == #wins - 1 then
                    -- Should quit, so we close all invalid windows.
                    for _, w in ipairs(invalid_win) do
                        vim.api.nvim_win_close(w, true)
                    end
                end
            end,
        })
    end,
    keys = {
        {
            "<Leader>nt",
            "<cmd>NvimTreeToggle<CR>",
            mode = { "n" },
            desc = "toggle NvimTree",
            silent = true,
        },
        {
            "<Leader>nf",
            ":NvimTreeFindFile<CR>",
            mode = { "n" },
            desc = "find current file in NvimTree",
            silent = true,
        },
    },
}
