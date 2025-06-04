local M = {}

-- restricted format
---@param bufnr number buffer to format
---@param allowed_clients string[] client names to allow formatting
local function format_by_client(bufnr, allowed_clients)
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
            if not allowed_clients then return true end
            return vim.tbl_contains(allowed_clients, client.name)
        end,
    })
end

---@param bufnr number
---@param allowed_clients string[]
local function register_format_on_save(bufnr, allowed_clients)
    local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function() format_by_client(bufnr, allowed_clients) end,
    })
end

---@param client vim.lsp.Client the lsp client instance
---@param bufnr number buffer we're attaching to
---@param format_opts table? how to deal with formatting, takes the following keys:
-- allowed_clients (string[]): names of the lsp clients that are allowed to handle vim.lsp.buf.format() when this client is attached
-- format_on_save (bool): whether or not to auto format on save
M.custom_attach = function(client, bufnr, format_opts)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    local with_desc = function(opts, desc) return vim.tbl_extend("force", opts, { desc = desc }) end

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, with_desc(keymap_opts, "Hover"))
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, with_desc(keymap_opts, "Goto Definition"))
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, with_desc(keymap_opts, "Find References"))
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, with_desc(keymap_opts, "Rename"))
    vim.keymap.set("n", "H", vim.lsp.buf.code_action, with_desc(keymap_opts, "Code Actions"))
    vim.keymap.set(
        "n",
        "<Leader>ti",
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        with_desc(keymap_opts, "Toggle inlay hints")
    )
    vim.keymap.set("n", "<Leader>rr", function()
        vim.lsp.stop_client(vim.lsp.get_clients())
        vim.cmd("edit")
    end, with_desc(keymap_opts, "Restart all LSP clients")) -- restart clients

    if format_opts ~= nil then
        vim.keymap.set(
            "n",
            "<leader>F",
            function() format_by_client(bufnr, format_opts.allowed_clients or { client.name }) end,
            with_desc(keymap_opts, "Format")
        ) -- format

        if format_opts.format_on_save then
            register_format_on_save(bufnr, format_opts.allowed_clients or { client.name })
        end
    end
end

---If the configured client's "cmd" is available, enable it
---Otherwise do nothing
---@param client string
M.register_if_installed = function(client)
    local config = vim.lsp.config[client]
    if config == nil or config.cmd == nil then return end

    local cmd = nil
    if type(config.cmd) == "table" then
        cmd = config.cmd[1]
    elseif type(config.cmd) == "string" then
        cmd = config.cmd
    end

    if cmd == nil then return end

    local output = vim.fn.trim(vim.fn.system({ "which", cmd }))

    if vim.fn.filereadable(output) then vim.lsp.enable(client) end
end

return M
