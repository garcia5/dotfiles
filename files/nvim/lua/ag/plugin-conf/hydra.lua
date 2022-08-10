local Hydra = require("hydra")

-- window resize mode
Hydra({
    name = "Resize",
    body = "<C-w>",
    config = {
        mode = { "n" },
        color = "red",
        invoke_on_body = true,
        hint = {
            type = "window",
            position = "middle",
            border = "rounded",
        },
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
        { "<C-h>", "<C-w>h", { silent = true, desc = "focus left" } },
        { "<C-j>", "<C-w>j", { silent = true, desc = "focus down" } },
        { "<C-k>", "<C-w>k", { silent = true, desc = "focus up" } },
        { "<C-l>", "<C-w>l", { silent = true, desc = "focus right" } },
    },
})

-- debug mode
local dap = require("dap")
local dapui = require("dapui")
Hydra({
    name = "Debug",
    body = "<leader>D",
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            type = "cmdline",
            position = "top",
            border = "rounded",
        },
        on_enter = function()
            dap.continue()
            dapui.open({})
        end,
        on_exit = function()
            dap.repl.close()
            dapui.close({})
        end,
    },
    heads = {
        { "c", dap.continue, { desc = "continue" } },
        { "s", dap.toggle_breakpoint, { desc = "toggle breakpoint" } },
        { "i", dap.step_into, { desc = "step into" } },
        { "o", dap.step_over, { desc = "step over" } },
        { "r", dap.repl.open, { desc = "open repl" } },
        { "K", dapui.eval, { desc = "eval variable" } },
        { "q", dap.terminate, { exit = true, desc = "terminate" } },
    },
})

-- git mode
local gs = require("gitsigns")
Hydra({
    name = "Git",
    hint = [[
 Stage/unstage hunks
 _s_: Stage hunk    _r_: Reset hunk         _S_: Stage buffer   _U_: Undo last stage
 ^
 Navigation
 _a_: All hunks     _n_, _gn_: Next hunk    _p_, _gp_: Prev hunk
 ^
 Display
 _=_: Preview hunk  _d_: Show deleted       _b_: Blame line
 ^
 _C_: Commit
 ^
 _q_, _<Esc>_: Quit
    ]],
    body = "<leader>G",
    config = {
        invoke_on_body = true,
        color = "pink", -- let me press other keys _without_ exiting git mode
        hint = {
            type = "window", -- one of "statusline", "cmdline", "window"
            position = "middle-right", -- only applies for type = "window"
            border = "rounded", -- only applies for type = "window"
        },
        on_enter = function()
            gs.toggle_linehl(true) -- light up changed lines
            gs.toggle_word_diff(true)
            gs.setqflist("all", { open = false }) -- all hunks in qf
        end,
        on_exit = function()
            gs.toggle_deleted(false)
            gs.toggle_linehl(false)
            gs.toggle_word_diff(false)
            vim.cmd("cclose") -- close quickfix
            vim.cmd("echo") -- clear the echo area
        end,
    },
    mode = { "n", "x" },
    heads = {
        { "gn", ":cn<CR>", { silent = true, desc = "next hunk" } },
        { "gp", ":cp<CR>", { silent = true, desc = "next hunk" } },
        { "n", gs.next_hunk, { desc = "next hunk" } },
        { "p", gs.prev_hunk, { desc = "next hunk" } },
        {
            "a",
            function() gs.setqflist("all", { open = true }) end,
            { desc = "set qflist" },
        },
        { "s", gs.stage_hunk, { desc = "stage hunk" } },
        { "U", gs.undo_stage_hunk, { desc = "undo stage" } },
        { "r", gs.reset_hunk, { desc = "reset hunk" } },
        { "S", gs.stage_buffer, { desc = "stage buffer" } },
        { "=", gs.preview_hunk, { desc = "preview hunk" } },
        { "b", gs.blame_line, { desc = "blame line" } },
        { "d", gs.toggle_deleted, { nowait = true, desc = "show deleted lines" } },
        { "C", ":tab Git commit<CR>", { silent = true, exit = true, desc = "commit changes" } },
        { "q", nil, { exit = true, nowait = true, desc = "quit" } },
        { "<Esc>", nil, { exit = true, nowait = true, desc = "quit" } },
    },
})
