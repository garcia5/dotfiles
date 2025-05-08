return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        explorer = {
            enabled = true,
        },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
            filter = function(buf)
                local disabled_buftypes = { "copilot-chat", "snacks_picker_input" }
                local buftype = vim.b[buf].buftype
                return not vim.tbl_contains(disabled_buftypes, buftype)
            end,
        },
        notifier = {
            enabled = true,
        },
        picker = {
            enabled = true,
            prompt = "» ",
            matcher = { fuzzy = true, smartcase = true, ignorecase = true, frecency = false },
            ui_select = true,
            formatters = {
                file = {
                    filename_first = false, -- display filename before the file path
                    truncate = 40, -- truncate the file path to (roughly) this length
                    filename_only = false, -- only show the filename
                    icon_width = 2, -- width of the icon (in characters)
                    git_status_hl = false, -- use the git status highlight group for the filename
                },
            },
            jump = {
                reuse_win = false, -- reuse an existing window if the buffer is already open
                jumplist = true, -- save current position in the jumplist
            },
            win = {
                list = {
                    keys = {
                        ["<c-x>"] = "edit_split",
                    },
                },
                input = {
                    keys = {
                        ["<c-x>"] = "edit_split",
                    },
                },
            },
            sources = {
                explorer = {
                    follow_file = true,
                    diagnostics = false,
                    diagnostics_open = false,
                    win = {
                        list = {
                            keys = {
                                ["<CR>"] = { "open_from_explorer" },
                            },
                        },
                    },
                },
            },
            -- always ask what window to open a file in if there are multiple open
            actions = {
                open_from_explorer = function(picker)
                    local cur_item = picker:current()
                    if cur_item.dir then
                        picker:action("confirm")
                    else
                        picker:action("pick_win")
                        picker:action("jump")
                    end
                end,
            },
        },
        statuscolumn = {
            enabled = true,
        },
    },
    keys = {
        -- pickers
        {
            "<leader>fb",
            function()
                require("snacks").picker.buffers({
                    win = {
                        input = {
                            keys = {
                                ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
                            },
                        },
                    },
                })
            end,
            desc = "Fuzzy find buffers",
        },
        { "<leader>ff", function() require("snacks").picker.files() end, desc = "Fuzzy find Files" },
        { "<leader>gg", function() require("snacks").picker.grep() end, desc = "Live grep" },
        { "<leader>qf", function() require("snacks").picker.qflist() end, desc = "Fuzzy find in qflist" },
        { "<leader>fl", function() require("snacks").picker.lines() end, desc = "Fuzzy find in file" },
        { "<leader>fs", function() require("snacks").picker.lsp_symbols() end, desc = "Find LSP symbols" },
        -- explorer (also a picker)
        { "<leader>nt", function() require("snacks").explorer.open() end, desc = "Open filetree" },
        { "<leader>nf", function() require("snacks").explorer.reveal() end, desc = "Open current file in filetree" },
    },
}
