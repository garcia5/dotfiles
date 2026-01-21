local install_parsers = {
    "bash",
    "css",
    "zsh",
    "python",
    "lua",
    "javascript",
    "typescript",
    "json",
    "csv",
    "swift",
    "yaml",
    "toml",
    "markdown",
}
if vim.fn.environ()["TREESITTER_INSTALL"] ~= nil then
    install_parsers = vim.split(vim.fn.environ()["TREESITTER_INSTALL"], ",")
end

local textobjects = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        select = {
            lookahead = true,
            selection_modes = {
                ["@function.outer"] = "V", -- linewise
            },
        },
    },
    init = function()
        --#region SWAP
        vim.keymap.set(
            "n",
            "<leader>l",
            function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end,
            { desc = "[Treesitter] Swap with right parameter", silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>h",
            function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end,
            { desc = "[Treesitter] Swap with right parameter", silent = true }
        )
        --#endregion SWAP

        --#region MOVE
        local move_maps = {
            class = {
                first = "[",
                last = "]",
            },
            func = {
                first = "(",
                last = ")",
            },
        }
        for t, vals in pairs(move_maps) do
            for which_direction, first_key in pairs(vals) do
                for which_end, second_key in pairs(vals) do
                    local first = which_direction == "first" and "previous" or "next"
                    local second = which_end == "first" and "start" or "end"
                    local func_name = "goto_" .. first .. "_" .. second
                    vim.keymap.set(
                        { "n", "x", "o" },
                        first_key .. second_key,
                        function() require("nvim-treesitter-textobjects.move")[func_name]("@" .. t .. ".outer") end,
                        {
                            desc = "[Treesitter]" .. func_name,
                            silent = true,
                        }
                    )
                end
            end
        end
        --#endregion MOVE

        --#region CUSTOM MOTIONS
        for _, t in ipairs({ "function", "class" }) do
            local first = t:sub(1, 1)
            vim.keymap.set(
                { "x", "o" },
                "a" .. first,
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@" .. t .. ".outer", "textobjects")
                end,
                {
                    desc = "[Treesitter] _ all " .. t,
                    silent = true,
                }
            )
            vim.keymap.set(
                { "x", "o" },
                "i" .. first,
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@" .. t .. ".inner", "textobjects")
                end,
                {
                    desc = "[Treesitter] _ in " .. t,
                    silent = true,
                }
            )
        end
        --#endregion CUSTOM MOTIONS
    end,
}

local ts = {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    opts = {
        install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter", "parsers"),
    },
    init = function()
        require("nvim-treesitter").install(install_parsers)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = install_parsers,
            callback = function()
                vim.treesitter.start()
                vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo[0][0].foldmethod = "expr"
            end,
        })
    end,
}

local ts_context = {
    "nvim-treesitter/nvim-treesitter-context",
    init = function()
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
            underline = true,
            sp = "Grey",
        })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {
            underline = true,
            sp = "Grey",
        })
    end,
    opts = {
        enable = false,
        max_lines = 5, -- How many lines the window should span
        min_window_height = 25,
        line_numbers = true,
        multiline_threshold = 5, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
    },
}

return {
    ts,
    ts_context,
    textobjects,
}
