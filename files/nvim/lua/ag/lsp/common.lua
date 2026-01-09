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

---Return a function that can be called to find all references to the symbol under the cursor _not including_ test files
---@param inclue_declaration boolean whether or not to include the symbol definition in the output (default `false`)
---@param test_file_filter fun(filename: string): boolean method that should return `true` if the given filename is a test file
---@return function
local function non_test_references(inclue_declaration, test_file_filter)
    return function()
        vim.lsp.buf.references({ includeDeclaration = inclue_declaration }, {
            on_list = function(options)
                local non_test_items = vim.tbl_filter(function(item)
                    local fname = item.filename or vim.api.nvim_buf_get_name(item.bufnr)
                    local is_test_file = test_file_filter(fname)
                    return not is_test_file
                end, options.items)
                vim.fn.setqflist(non_test_items, "r")
                if #non_test_items == 0 then
                    vim.print("No references found")
                    return
                end
                vim.cmd("copen")
                if #non_test_items == 1 then vim.cmd("cfirst") end
            end,
        })
    end
end

---Register keymap to organize imports
---@param client vim.lsp.Client
---@param bufnr integer
local function register_organize_imports(client, bufnr)
    vim.keymap.set(
        "n",
        "<Leader>ii",
        function()
            vim.lsp.buf.code_action({
                context = {
                    diagnostics = vim.diagnostic.get(bufnr),
                    only = {
                        "source.organizeImports",
                    },
                },
                apply = true,
            })
        end,
        { buffer = bufnr, desc = client.name .. ": Organize Imports", silent = true, noremap = true }
    )
end

---@class LspFormatOpts
---@field format_on_save? boolean whether or not the client should automatically format on save
---
---@class LspReferenceOpts
---@field test_file_filter? fun(fname: string): boolean a function that returns `true` if the given file name is a test file
---@field inclue_declaration? boolean whether or not to include the symbol definition in the output (default `false`)
---
---@class LspCodeActionOpts
---@field register_organize_imports? boolean whether or not to register the organize imports keybinding
---
---@class LspOpts
---@field format? LspFormatOpts client formatting behavior
---@field references? LspReferenceOpts client "goto references" behavior
---@field code_actions? LspCodeActionOpts client code action behavior

---@type LspOpts
local default_opts = {
    format = {
        format_on_save = false,
    },
    code_actions = {
        register_organize_imports = false,
    },
    references = {
        inclue_declaration = false,
        test_file_filter = function(_) return false end,
    },
}

---@param client vim.lsp.Client the lsp client instance
---@param bufnr number buffer we're attaching to
---@param opts LspOpts? Options to register special functionality for some clients
M.custom_attach = function(client, bufnr, opts)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    local with_desc = function(desc) return vim.tbl_extend("force", keymap_opts, { desc = desc }) end

    ---@type LspOpts
    local resolved_opts = vim.tbl_extend("force", default_opts, opts or {})

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, with_desc("Hover"))
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, with_desc("Goto Definition"))
    vim.keymap.set(
        "n",
        "<leader>ga",
        function() vim.lsp.buf.references({ includeDeclaration = false }) end,
        with_desc("All LSP References")
    )
    if resolved_opts.references.test_file_filter then
        vim.keymap.set(
            "n",
            "<Leader>gr",
            non_test_references(false, resolved_opts.references.test_file_filter),
            with_desc("Non-test LSP References")
        )
    end
    if resolved_opts.code_actions.register_organize_imports then register_organize_imports(client, bufnr) end
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

    if resolved_opts.format.format_on_save then register_format_on_save(bufnr) end
end

return M
