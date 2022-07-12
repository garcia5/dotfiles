local dap = require("dap")
local dapui = require("dapui")

dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/vscode-node-debug2/out/src/nodeDebug.js" },
}
dap.configurations.typescript = {
    {
        type = "node2",
        request = "attach",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        skipFiles = { "<node_internals>/**/*.js" },
        port = 9229,
    },
}

-- map 'K' to hover while debug session is active
local keymap_restore = {}
dap.listeners.after["event_initialized"]["hover"] = function()
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
        for _, keymap in pairs(keymaps) do
            if keymap.lhs == "K" then
                table.insert(keymap_restore, keymap)
                vim.api.nvim_buf_del_keymap(buf, "n", "K")
            end
        end
    end
    vim.api.nvim_set_keymap("n", "K", "<Cmd>lua require('dapui').eval()<CR>", { silent = true })
end

dap.listeners.after["event_terminated"]["hover"] = function()
    for _, keymap in pairs(keymap_restore) do
        vim.api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
    end
    keymap_restore = {}
end

-- automatically open/close the sidebar when debugging starts
dap.listeners.after["event_stopped"]["dapui_config"] = function() dapui.open({ layout = nil }) end
dap.listeners.before["event_terminated"]["dapui_config"] = function() dapui.close({ layout = nil }) end
dap.listeners.before["event_exited"]["dapui_config"] = function() dapui.close({ layout = nil }) end

dapui.setup({
    layouts = {
        {
            elements = {
                "scopes",
                "breakpoints",
            },
            position = "left",
            size = 40,
        },
        {
            elements = {
                "repl",
            },
            position = "bottom",
            size = 10,
        },
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "rounded", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
})

-- -- open variable sidebar on breakpoint
-- dap.listeners.after["event_stopped"]["scopes"] = function()
--     local widgets = require("dap.ui.widgets")
--     widgets.sidebar(widgets.scopes).open()
-- end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "WarningMsg", linehl = "", numhl = "" })
