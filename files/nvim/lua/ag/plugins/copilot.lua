local copilot = {
    "zbirenbaum/copilot.lua",
    -- copilot.lua bundles the copilot LSP - make sure it's always available for other tools to use
    init = function() vim.lsp.enable("copilot") end,
    opts = {
        -- suggestion + panel settings as suggested by blink-copilot integration
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
        model = "claude-sonnet-4", -- default model
        auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
        insert_at_end = false, -- Move cursor to end of buffer when inserting text
        sticky = { "@copilot" }, -- automatically use copilot tools in every sesssion
        -- open window in right 1/3rd of window
        window = {
            layout = "vertical",
            width = 0.3,
            title = " Copilot Chat",
        },
        headers = {
            user = "󰀉 User",
            assistant = "󰚩 Assistant",
            tool = "󱁤 Tool",
        },
        -- Use render-markdown for nicer rendering
        highlight_headers = true,
        separator = "---",
        error_header = "> [!ERROR] Error",
        -- custom prompts
        prompts = {
            PythonExpert = {
                system_prompt = "You are an expert Python developer with knowledge of language best practices, helping an experienced software engineer in their day to day work",
            },
        },
        -- custom functions for copilot agent to use
        functions = {
            pytest = {
                group = "copilot",
                description = "Collect unit test outputs for the current project using pytest. Requires a python project with pytest installed",
                resolve = function(_, source)
                    local utils = require("CopilotChat.utils")
                    utils.schedule_main()
                    local venv = require("ag.utils").get_python_venv_path()
                    local pytest_cmd
                    if venv == nil then
                        pytest_cmd = "pytest"
                    else
                        pytest_cmd = venv .. "/bin/pytest"
                    end

                    if not vim.fn.executable(pytest_cmd) then error("Pytest installation not found: " .. pytest_cmd) end
                    local cmd = { pytest_cmd, "-v", source.cwd() }

                    local out = utils.system(cmd)

                    return {
                        {
                            data = out.stdout,
                        },
                    }
                end,
            },
        },
        -- custom mappings within copilot chat buffer
        mappings = {
            submit_prompt = {
                normal = "<CR>",
                insert = "<C-y>",
            },
            accept_diff = {
                normal = "<C-s>",
                insert = "<C-s>",
            },
            -- make it hard to accidentally reset the chat
            reset = {
                normal = "ggr",
                insert = "<C-r><C-y>",
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
                    "#buffers",
                    "#gitdiff",
                }
                if vim.bo.filetype == "python" then table.insert(sticky, "/PythonExpert") end

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
        "CopilotChatLoad",
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
