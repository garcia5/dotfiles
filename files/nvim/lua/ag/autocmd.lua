local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local exit_if_last = function()
    if vim.fn.winnr("$") == 1 then
        vim.cmd("q")
    end
end

-- Global formatopts
au("BufEnter", {
    pattern = "*",
    callback = function()
        local buftype = vim.opt.buftype:get()
        if buftype ~= "terminal" and buftype ~= "gitcommit" then
            vim.opt.formatoptions = "lcrqj"
        end
    end,
})

local format_on_save = function()
    local lang = vim.opt.filetype:get()

    if lang == "ts" then
        vim.lsp.buf.formatting_seq_sync(nil, nil, { "tsserver", "null-ls" })
    else
        vim.lsp.buf.formatting_seq_sync()
    end

    if vim.fn.exists("EslintFixAll") == 1 then
        vim.cmd("EslintFixAll")
    end
end

au("BufWritePre", {
    pattern = { "*.ts", "*.vue", "*.lua", "*.js" },
    callback = format_on_save,
})

local term_group = augroup("term", { clear = false })
au("TermOpen", {
    group = term_group,
    pattern = "*",
    callback = function()
        vim.cmd("startinsert")
        vim.bo.number = false
        vim.bo.relativenumber = false
        vim.bo.cursorline = false
        vim.bo.signcolumn = false
        vim.bo.indent_blankline_enabled = false
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
    command = "vim.bo.EditorConfig_disable = true",
})

au("BufEnter", {
    pattern = "Dockerfile.*",
    command = "vim.bo.filetype = 'Dockerfile'",
})

local nvim_tree_group = augroup("NvimTree", { clear = true })
au("FileType", {
    group = nvim_tree_group,
    pattern = "NvimTree",
    callback = function()
        exit_if_last()
        vim.bo.cursorline = true
    end,
})

-- Open kitty with all folds closed
au("BufReadPost", {
    pattern = "kitty.conf",
    command = "vim.bo.foldlevel = 0",
})

-- Aerial specific mapping
au("FileType", {
    pattern = "aerial",
    callback = function()
        vim.keymap.set("n", "q", ":q<CR>", { noremap = true, silent = true, buffer = true })
    end,
})
