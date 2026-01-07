local M = {}

local allowed_formatters = {
    "ruff",
    "efm",
    "rust_analyzer",
    "gopls",
    "dartls",
}

-- restricted format
---@param bufnr number buffer to format
local function format_by_client(bufnr)
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client) return vim.tbl_contains(allowed_formatters, client.name) end,
    })
end

---@param bufnr number
local function register_format_on_save(bufnr)
    local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function() format_by_client(bufnr) end,
    })
end

---@param client vim.lsp.Client the lsp client instance
---@param bufnr number buffer we're attaching to
---@param format_opts table? how to deal with formatting, takes the following keys:
-- format_on_save (bool): whether or not to auto format on save
M.custom_attach = function(client, bufnr, format_opts)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    local with_desc = function(desc) return vim.tbl_extend("force", keymap_opts, { desc = desc }) end

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, with_desc("Hover"))
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, with_desc("Goto Definition"))
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, with_desc("Find References"))
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, with_desc("Rename"))
    vim.keymap.set("n", "<Leader>gi", vim.lsp.buf.implementation, with_desc("Implementations"))
    vim.keymap.set("n", "H", vim.lsp.buf.code_action, with_desc("Code Actions"))
    vim.keymap.set(
        "n",
        "<Leader>ti",
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        with_desc("Toggle inlay hints")
    )
    vim.keymap.set("n", "<Leader>rr", function()
        vim.lsp.stop_client(vim.lsp.get_clients())
        vim.cmd("edit")
    end, with_desc("Restart all LSP clients")) -- restart clients

    vim.keymap.set("n", "<leader>F", function() format_by_client(bufnr) end, with_desc("Format")) -- format

    if format_opts ~= nil and format_opts.format_on_save then register_format_on_save(bufnr) end
end

return M
