local copilot = {
    "zbirenbaum/copilot.lua",
    keys = {
        {
            "<C-.>",
            function() require("copilot.suggestion").next() end,
            mode = "i",
            desc = "Next copilot suggestion",
        },
        {
            "<C-,>",
            function() require("copilot.suggestion").prev() end,
            mode = "i",
            desc = "Prev copilot suggestion",
        },
        {
            "<C-/>",
            function() require("copilot.suggestion").accept_line() end,
            mode = "i",
            desc = "Accept copilot suggestion",
        },
    },
    cmd = {
        "Copilot",
    },
    opts = {
        suggestion = {
            enabled = true,
            auto_trigger = false,
            hide_during_completion = true,
            keymap = {
                accept = "<C-/>",
                next = "<C-.>",
                prev = "<C-,>",
                dismiss = "<C-c>",
            },
        },
        panel = {
            enabled = true,
            keymap = {
                jump_prev = "cp",
                jump_next = "cn",
                accept = "<CR>",
                refresh = "gr",
            },
        },
        filetypes = {
            markdown = false,
            gitrebase = false,
            help = false,
            gitcommit = false,
            ["*"] = true,
        },
    },
    init = function()
        -- auto show/hide when cmp menu is active
        local success, cmp = pcall(require, "cmp")
        if not success then return end
        cmp.event:on("menu_opened", function() vim.b.copilot_suggestion_hidden = true end)
        cmp.event:on("menu_closed", function() vim.b.copilot_suggestion_hidden = false end)
    end,
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
        window = {
            layout = "float",
            border = "rounded",
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
            "<Leader>cc",
            function()
                -- make sure telescope UI select is loaded first
                require("telescope").load_extension("ui-select")

                -- Pick a prompt using vim.ui.select
                local actions = require("CopilotChat.actions")
                actions.pick(actions.prompt_actions({
                    selection = require("CopilotChat.select").visual,
                }))
            end,
            mode = { "n", "v" },
            desc = "Copilot Chat Action",
        },
        {
            "<Leader>co",
            function() require("CopilotChat").open() end,
            mode = { "n", "v" },
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
    },
}

return {
    copilot,
    chat,
}
