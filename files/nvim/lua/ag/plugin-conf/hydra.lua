local Hydra = require("hydra")

local dap = require("dap")
local dapui = require("dapui")
-- Debug mode
Hydra({
    name = "Debug",
    hint = [[
        _c_ : Continue   _b_ : Toggle Breakpoint
        _i_ : Step Into  _o_ : Step Over
        _q_ : Terminate
    ]],
    body = "<leader>d",
    config = {
        color = "pink",
        hint = {
            position = "bottom",
            border = "rounded",
        },
        on_enter = function() vim.bo.modifiable = false end,
        on_exit = function() dapui.close() end,
    },
    heads = {
        { "c", dap.continue },
        { "b", dap.toggle_breakpoint },
        { "i", dap.step_into },
        { "o", dap.step_over },
        { "q", dap.terminate, { exit = true } },
    },
})

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
            position = "bottom",
            border = "rounded",
        },
        on_enter = function() gs.toggle_linehl(true) end,
        on_exit = function()
            gs.toggle_deleted(false)
            gs.toggle_linehl(false)
            vim.cmd("echo") -- clear the echo area
        end,
    },
    mode = { "n", "x" },
    heads = {
        { "n", gs.next_hunk },
        { "p", gs.prev_hunk },
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
