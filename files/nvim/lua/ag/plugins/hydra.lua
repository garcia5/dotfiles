return {
    "anuvyklack/hydra.nvim",
    keys = {
        "<Leader>G",
        "<Leader>D",
        "<C-w>",
    },
    config = function()
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
            hint = [[
 Run
 _c_: Continue              _i_: Step Into          _o_: Step Over          _r_: Run to cursor
 ^

 Interact
 _K_: Inspect variable      _s_: Toggle breakpoint  _a_: List breakpoints
 ^

 Exit
 _q_: Terminate debugger    _<Esc>_: Close UI
    ]],
            body = "<leader>D",
            config = {
                color = "pink",
                invoke_on_body = true,
                hint = {
                    type = "window",
                    position = "middle-right",
                    border = "rounded",
                },
                on_enter = function()
                    dap.continue()
                    dapui.open({})
                end,
                on_exit = function() dapui.close({}) end,
            },
            heads = {
                { "c", dap.continue },
                { "r", dap.run_to_cursor },
                { "s", dap.toggle_breakpoint },
                { "a", dap.list_breakpoints },
                { "i", dap.step_into },
                { "o", dap.step_over },
                { "K", dapui.eval },
                { "q", dap.terminate, { exit = true, desc = "terminate" } },
                { "<Esc>", nil, { exit = true, desc = "exit" } },
            },
        })

        -- git mode
        local gs = require("gitsigns")
        local sidebar = require("sidebar-nvim")
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
 _q_: Quit
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
                    gs.toggle_signs(true)
                    gs.toggle_deleted(true) -- show deleted lines
                    gs.toggle_linehl(true) -- light up changed lines
                    gs.toggle_word_diff(true) -- highlight changed words
                    gs.setqflist("all", { open = false }) -- all hunks in qf, but don't open qf list
                    sidebar.open()
                end,
                on_exit = function()
                    gs.toggle_deleted(false)
                    gs.toggle_linehl(false)
                    gs.toggle_word_diff(false)
                    vim.cmd("echo") -- clear the echo area
                    vim.cmd("ccl") -- close qf list
                    sidebar.close()
                end,
            },
            mode = { "n", "x" },
            heads = {
                { "gn", ":cn<CR>", { silent = true, desc = "next hunk" } },
                { "gp", ":cp<CR>", { silent = true, desc = "prev hunk" } },
                { "n", gs.next_hunk, { desc = "next hunk" } },
                { "p", gs.prev_hunk, { desc = "prev hunk" } },
                {
                    "a",
                    function()
                        gs.setqflist("all", { open = true })
                        vim.cmd("cc")
                    end,
                    { desc = "set qflist" },
                },
                {
                    "s",
                    function()
                        gs.stage_hunk()
                        sidebar.update()
                    end,
                    { desc = "stage hunk" },
                },
                {
                    "U",
                    function()
                        gs.undo_stage_hunk()
                        sidebar.update()
                    end,
                    { desc = "undo stage" },
                },
                {
                    "r",
                    function()
                        gs.reset_hunk()
                        sidebar.update()
                    end,
                    { desc = "reset hunk" },
                },
                {
                    "S",
                    function()
                        gs.stage_buffer()
                        sidebar.update()
                    end,
                    { desc = "stage buffer" },
                },
                { "=", gs.preview_hunk, { desc = "preview hunk" } },
                { "b", gs.blame_line, { desc = "blame line" } },
                { "d", gs.toggle_deleted, { nowait = true, desc = "show deleted lines" } },
                { "C", ":tab Git commit<CR>", { silent = true, exit = true, desc = "commit changes" } },
                { "q", nil, { exit = true, nowait = true, desc = "quit" } },
            },
        })
    end,
}
