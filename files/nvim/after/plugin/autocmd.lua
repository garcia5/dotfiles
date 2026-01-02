local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local term_group = augroup("term", { clear = false })
au("TermOpen", {
    group = term_group,
    pattern = "*",
    desc = "Terminal display configuration",
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
    desc = "Auto enter insert mode when entering terminal buffer",
    callback = function()
        local buftype = vim.opt.buftype:get()
        if buftype == "terminal" then
            vim.cmd("startinsert")
        end
    end,
})

au("BufEnter", {
    pattern = "*",
    desc = "Never auto-format text in insert mode",
    command = "set formatoptions-=t",
})

au("VimResized", {
    command = "wincmd =",
    desc = "Keep splits even when vim resized",
})

au("BufEnter", {
    pattern = "Dockerfile.*",
    desc = "Detect Dockerfiles with different extensions",
    callback = function() vim.opt_local.filetype = "dockerfile" end,
})

au("BufEnter", {
    pattern = "Bogiefile",
    desc = "Bogiefiles are always yaml",
    callback = function() vim.opt_local.filetype = "yaml" end,
})

au("BufEnter", {
    pattern = "*.tmTheme",
    callback = function() vim.opt_local.filetype = "tmTheme" end,
})

au("BufReadPost", {
    pattern = "kitty.conf",
    desc = "Open kitty with all folds closed",
    callback = function() vim.opt_local.foldlevel = 0 end,
})
