local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local exit_if_last = function()
    if vim.fn.winnr("$") == 1 then vim.cmd("q") end
end

-- Global formatopts
au("BufEnter", {
    pattern = "*",
    callback = function()
        local buftype = vim.opt.buftype:get()
        if buftype ~= "terminal" then vim.opt.formatoptions = "lcrqjn" end
    end,
})

local term_group = augroup("term", { clear = false })
au("TermOpen", {
    group = term_group,
    pattern = "*",
    callback = function()
        vim.cmd("startinsert")
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = false
        vim.opt_local.signcolumn = "no"
    end,
})
au("BufEnter", {
    group = term_group,
    pattern = "*",
    callback = function()
        local buftype = vim.opt.buftype:get()
        if buftype == "terminal" then
            -- quit if the terminal is the last buffer open
            exit_if_last()
            -- enter insert mode automatically when entering terminal
            vim.cmd("startinsert")
        end
    end,
})

local gitcommit_group = augroup("gitcommit", { clear = true })
au("FileType", {
    group = gitcommit_group,
    pattern = "gitcommit",
    callback = function() vim.opt_local.formatoptions = "tcrnqj" end,
})

au("BufEnter", {
    pattern = "Dockerfile.*",
    callback = function() vim.opt_local.filetype = "Dockerfile" end,
})

au("BufEnter", {
    pattern = "*.tmTheme",
    callback = function() vim.opt_local.filetype = "tmTheme" end,
})

local nvim_tree_group = augroup("NvimTree", { clear = true })
au("FileType", {
    group = nvim_tree_group,
    pattern = "NvimTree",
    callback = function()
        exit_if_last()
        vim.opt_local.cursorline = true
    end,
})

-- Open kitty with all folds closed
au("BufReadPost", {
    pattern = "kitty.conf",
    callback = function() vim.opt_local.foldlevel = 0 end,
})

-- Aerial specific mapping
au("FileType", {
    pattern = "aerial",
    callback = function() vim.keymap.set("n", "q", ":q<CR>", { noremap = true, silent = true, buffer = true }) end,
})

-- Enable treesitter powered indent for vue files only
au("FileType", {
    pattern = "vue",
    command = "TSBufEnable indent",
})

au("FileType", {
    pattern = "qf",
    command = "set number",
})

-- EZ rebase keybinds
au("FileType", {
    pattern = "gitrebase",
    callback = function()
        for _, key in ipairs({ "p", "r", "e", "s", "f", "d", "x", "b", "l", "r", "t", "m" }) do
            vim.keymap.set("n", key, "ciw" .. key .. "<Esc>", { noremap = true, silent = true, buffer = true })
        end
    end,
})

-- Debugger repl autocomplete
au("FileType", {
    pattern = "dap-repl",
    callback = function() require("dap.ext.autocompl").attach() end,
})
