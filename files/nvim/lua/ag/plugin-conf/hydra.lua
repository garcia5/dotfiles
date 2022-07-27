local Hydra = require("hydra")

-- window resize mode
Hydra({
    name = "Resize",
    body = "<C-w>",
    config = {
        mode = { "n" },
        color = "red",
        invoke_on_body = true,
    },
    heads = {
        { "r", "<C-w>r", { silent = true, desc = "rotate (clockwise)" } },
        { "R", "<C-w>R", { silent = true, desc = "Rotate (counter clockwise)" } },
        { "x", "<C-w>x", { silent = true, desc = "eXchange" } },
        { "H", "<C-w>H", { silent = true, desc = "move left" } },
        { "J", "<C-w>J", { silent = true, desc = "move down" } },
        { "K", "<C-w>K", { silent = true, desc = "move up" } },
        { "L", "<C-w>L", { silent = true, desc = "move right" } },
        { "<", "<C-w><", { silent = true, desc = "shrink horizontally" } },
        { "-", "<C-w>-", { silent = true, desc = "shrink vertically" } },
        { "+", "<C-w>+", { silent = true, desc = "grow vertically" } },
        { ">", "<C-w>>", { silent = true, desc = "grow horizontally" } },
        { "=", "<C-w>=", { silent = true, desc = "equalize sizes", exit = true } },
        { "<C-h>", "<C-w>h", { silent = true } },
        { "<C-j>", "<C-w>j", { silent = true } },
        { "<C-k>", "<C-w>k", { silent = true } },
        { "<C-l>", "<C-w>l", { silent = true } },
    },
})

-- debug mode
local dap = require("dap")
Hydra({
    name = "Debug",
    hint = [[
        _c_ : Continue    _s_ : Toggle Breakpoint
        _i_ : Step Into   _o_ : Step Over
        _r_ : Toggle repl

        _q_ : Terminate
    ]],
    body = "<leader>D",
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "top-right",
            border = "rounded",
        },
        on_exit = function()
            dap.terminate()
            dap.repl.close()
        end,
    },
    heads = {
        { "c", dap.continue },
        { "s", dap.toggle_breakpoint },
        { "i", dap.step_into },
        { "o", dap.step_over },
        { "r", dap.repl.open },
        { "q", dap.terminate, { exit = true } },
    },
})

-- git mode
local gs = require("gitsigns")
Hydra({
    name = "Git",
    hint = [[
        _=_ : Preview hunk   _a_ : All hunks
        _n_ : Next hunk      _p_ : Prev hunk
        _s_ : Stage hunk     _r_ : Reset hunk
        _S_ : Stage buffer   _u_ : Undo last stage
        _d_ : Toggle deleted _b_ : Blame line
        _B_ : Blame full     _C_ : Commit
    ]],
    body = "<leader>G",
    config = {
        invoke_on_body = true,
        color = "pink", -- let me press other keys _without_ exiting git mode
        hint = {
            position = "top-right",
            border = "rounded",
        },
        on_enter = function()
            gs.toggle_linehl(true) -- light up changed lines
            gs.toggle_deleted(true) -- show deleted lines
            gs.setqflist("all", { open = true }) -- all hunks in qf
        end,
        on_exit = function()
            gs.toggle_deleted(false)
            gs.toggle_linehl(false)
            vim.cmd("cclose") -- close quickfix
            vim.cmd("echo") -- clear the echo area
        end,
    },
    mode = { "n", "x" },
    heads = {
        { "n", ":cn<CR>", { silent = true } },
        { "p", ":cp<CR>", { silent = true } },
        {
            "a",
            function() gs.setqflist("all", { open = true }) end,
        },
        { "s", gs.stage_hunk },
        { "u", gs.undo_stage_hunk },
        { "r", gs.reset_hunk },
        { "S", gs.stage_buffer },
        { "=", gs.preview_hunk },
        { "d", gs.toggle_deleted, { nowait = true } },
        { "b", gs.blame_line },
        {
            "B",
            function() gs.blame_line({ full = true }) end,
        },
        { "C", ":tab Git commit<CR>", { silent = true, exit = true } },
        { "q", nil, { exit = true, nowait = true } },
        { "<Esc>", nil, { exit = true, nowait = true } },
    },
})
