local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local exit_if_last = function()
    if vim.fn.winnr("$") == 1 then vim.cmd("q") end
end

-- Global formatopts
au("BufEnter", {
    pattern = "*",
    desc = "Set global formatopts",
    callback = function()
        local buftype = vim.opt.buftype:get()
        if buftype ~= "terminal" then vim.opt.formatoptions = "lcrqjn" end
    end,
})

au("VimResized", {
    desc = "Equalize splits automatically",
    callback = function ()
        vim.cmd("wincmd =")
    end
})

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
    desc = "gitcommit formatopts",
    pattern = "gitcommit",
    callback = function() vim.opt_local.formatoptions = "tcrnqj" end,
})

au("BufEnter", {
    pattern = "Dockerfile.*",
    desc = "Detect Dockerfiles with different extensions",
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
    desc = "Quit nvim if NvimTree is the only buffer",
    callback = function()
        exit_if_last()
        vim.opt_local.cursorline = true
    end,
})

au("BufReadPost", {
    pattern = "kitty.conf",
    desc = "Open kitty with all folds closed",
    callback = function() vim.opt_local.foldlevel = 0 end,
})

-- Aerial specific mapping
au("FileType", {
    pattern = "aerial",
    callback = function() vim.keymap.set("n", "q", ":q<CR>", { noremap = true, silent = true, buffer = true, desc = "quit aerial" }) end,
})

au("FileType", {
    pattern = "vue",
    desc = "Treesitter indenting for vue files",
    command = "TSBufEnable indent",
})

au("FileType", {
    pattern = "qf",
    command = "set number",
})

au("FileType", {
    pattern = "gitrebase",
    desc = "EZ rebase keybinds",
    callback = function()
        for _, key in ipairs({ "p", "r", "e", "s", "f", "d", "x", "b", "l", "r", "t", "m" }) do
            vim.keymap.set("n", key, "ciw" .. key .. "<Esc>", { noremap = true, silent = true, buffer = true })
        end
    end,
})

au("FileType", {
    pattern = "yaml",
    desc = "Only start yamlls for files that are not pnpm-lock.yaml",
    callback = function (event)
        -- pnpm-lock file, do nothing
        if string.find(event.file, "pnpm%-lock.yaml") then
            return
        end
        -- yamlls already running, do nothing
        local clients = vim.lsp.get_active_clients()
        for _, client in ipairs(clients) do
            if client.name == "yamlls" then
                return
            end
        end

        -- Start yaml language server
        vim.cmd([[LspStart yamlls]])
    end
})

-- Debugger repl autocomplete
au("FileType", {
    pattern = "dap-repl",
    callback = function() require("dap.ext.autocompl").attach() end,
})
