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
    opts = {
        debug = false,
        model = "claude-3.5-sonnet",
        window = {
            layout = "float",
            border = "rounded",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
        },
        {
            -- Uses visual selection or falls back to buffer
            selection = function(source)
                return require("CopilotChat.select").visual(source) or require("CopilotChat.select").buffer(source)
            end,
        },
        prompts = {
            PythonExpert = {
                system_prompt = "You are an expert Python developer with knowledge of language best practices, helping an experienced software engineer in their day to day work",
            },
        },
        mappings = {
            -- Swap default "submit" and "accept" mappings - I don't really use diff mappings and <C-y> is more common for me
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
            function ()
                require("CopilotChat").ask("#buffer /Docs", {
                    window = {
                        layout = "float",
                        relative = "cursor",
                        width = 1,
                        height = 0.4,
                        row = 1,
                    }
                })
            end,
            mode = { "n", "v" },
            desc = "Generate docs for selected code",
        },
        {
            "<Leader>ct",
            function ()
                require("CopilotChat").ask("#buffer /Tests", {
                    window = {
                        layout = "float",
                        relative = "cursor",
                        width = 1,
                        height = 0.4,
                        row = 1,
                    }
                })
            end,
            mode = { "n", "v" },
            desc = "Generate tests for selected code",
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
}

return {
    copilot,
    chat,
}
