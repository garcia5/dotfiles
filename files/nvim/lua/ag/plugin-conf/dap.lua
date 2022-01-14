local dap = require("dap")

-- typescript + nest
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
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "WarningMsg", linehl = "", numhl = "" })
