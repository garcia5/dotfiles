local copilot = {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = {
        "Copilot",
    },
    opts = {
        suggestion = {
            enabled = false,
        },
        panel = {
            enabled = false,
        },
        filetypes = {
            markdown = false,
            gitrebase = false,
            help = false,
            ["*"] = true,
        },
    },
}

local chat = {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
        debug = false,
        model = "claude-sonnet-4",
        window = {
            layout = "vertical",
            width = 0.3,
            title = " Copilot Chat",
        },
        headers = {
            user = "󰀉",
            assistant = "󰚩",
            tool = "󱁤",
        },
        highlight_headers = true,
        separator = "---",
        error_header = "> [!ERROR] Error",
        prompts = {
            PythonExpert = {
                system_prompt = "You are an expert Python developer with knowledge of language best practices, helping an experienced software engineer in their day to day work",
            },
        },
        mappings = {
            submit_prompt = {
                normal = "<CR>",
                insert = "<C-y>",
            },
            accept_diff = {
                normal = "<C-s>",
                insert = "<C-s>",
            },
        },
    },
    keys = {
        {
            "<Leader>co",
            function() require("CopilotChat").open() end,
            mode = { "n", "v" },
        },
        {
            "<Leader>cd",
            function()
                local sticky = {
                    "#buffers", "#gitdiff",
                }
                if vim.bo.filetype == "python" then
                    table.insert(sticky, "/PythonExpert")
                end

                require("CopilotChat").ask(
                    "Please update the comments, docstrings, and unit tests related to my changed code",
                    {
                        sticky = sticky,
                    }
                )
            end,
            mode = { "n", "v" },
            desc = "Update tests, docstrings based on new changes",
        },
    },
    cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatToggle",
        "CopilotChatExplain",
        "CopilotChatReview",
        "CopilotChatFix",
        "CopilotChatOptimize",
        "CopilotChatDocs",
        "CopilotChatTests",
        "CopilotChatFixDiagnostic",
        "CopilotChatCommit",
        "CopilotChatCommitStaged",
        "CopilotChatModels",
    },
    init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "copilot-*",
            callback = function()
                vim.opt_local.relativenumber = false
                vim.opt_local.number = false
            end,
        })
    end,
}

return {
    copilot,
    chat,
}
