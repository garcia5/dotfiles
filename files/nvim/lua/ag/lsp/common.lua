local M = {}

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

local allowed_formatters = {
    "ruff",
    "efm",
    "rust_analyzer",
    "gopls",
    "dartls",
}

---@param bufnr integer
---@param desc string
---@return vim.keymap.set.Opts
local function keymap_opts(bufnr, desc)
    return {
        buffer = bufnr,
        desc = desc,
        silent = true,
        noremap = true,
    }
end

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

---Find all references to the symbol under the cursor _not including_ test files
---@param bufnr integer
---@param opts LspReferenceOpts
local function register_non_test_references(bufnr, opts)
    vim.keymap.set("n", "<leader>gr", function()
        vim.lsp.buf.references({ includeDeclaration = opts.inclue_declaration }, {
            on_list = function(options)
                local non_test_items = vim.tbl_filter(function(item)
                    local fname = item.filename or vim.api.nvim_buf_get_name(item.bufnr)
                    local is_test_file = opts.test_file_filter(fname)
                    return not is_test_file
                end, options.items)
                vim.fn.setqflist({}, "r", {
                    title = options.title or "References",
                    items = non_test_items,
                })
                if #non_test_items == 0 then
                    vim.print("No references found")
                    return
                end
                vim.cmd("copen")
                if #non_test_items == 1 then vim.cmd("cfirst") end
            end,
        })
    end, keymap_opts(bufnr, "Non-test LSP References"))
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
        keymap_opts(bufnr, client.name .. ": Organize Imports")
    )
end

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
        test_file_filter = nil,
    },
}

---@param client vim.lsp.Client the lsp client instance
---@param bufnr number buffer we're attaching to
---@param opts LspOpts? Options to register special functionality for some clients
M.custom_attach = function(client, bufnr, opts)
    ---@type LspOpts
    local resolved_opts = vim.tbl_extend("force", default_opts, opts or {})

    local mappings = {
        {
            left = "K",
            right = function() vim.lsp.buf.hover({ border = "rounded" }) end,
            desc = "Hover",
        },
        {
            left = "<c-]>",
            right = vim.lsp.buf.definition,
            desc = "Goto Definition",
        },
        {
            left = "<leader>ga",
            right = function() vim.lsp.buf.references({ includeDeclaration = false }) end,
            desc = "All LSP references",
        },
        {
            left = "gr",
            right = vim.lsp.buf.rename,
            desc = "LSP Rename",
        },
        {
            left = "<leader>gi",
            right = vim.lsp.buf.implementation,
            desc = "LSP Implementations",
        },
        {
            left = "H",
            right = vim.lsp.buf.code_action,
            desc = "LSP Code Actions",
        },
        {
            left = "<leader>ti",
            right = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
            desc = "Toggle inlay hints",
        },
        {
            left = "<Leader>F",
            right = function() format_by_client(bufnr) end,
            desc = "LSP Format",
        },
    }
    for _, map in ipairs(mappings) do
        vim.keymap.set("n", map.left, map.right, keymap_opts(bufnr, map.desc))
    end

    if resolved_opts.references.test_file_filter then register_non_test_references(bufnr, resolved_opts.references) end
    if resolved_opts.code_actions.register_organize_imports then register_organize_imports(client, bufnr) end
    if resolved_opts.format.format_on_save then register_format_on_save(bufnr) end
end

return M
