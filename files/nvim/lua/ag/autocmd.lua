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
        if buftype ~= "terminal" and buftype ~= "gitcommit" then vim.opt.formatoptions = "lcrqj" end
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

au("FileType", {
    pattern = "gitcommit",
    command = "let b:EditorConfig_disable = 1",
})

au("BufEnter", {
    pattern = "Dockerfile.*",
    callback = function() vim.opt_local.filetype = "Dockerfile" end,
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
