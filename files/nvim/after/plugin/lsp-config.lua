vim.lsp.log.set_level(vim.log.levels.INFO)

local clients = {
    "bashls",
    "dartls",
    "efm",
    "gopls",
    "jsonls",
    "lua_ls",
    "basedpyright",
    "ruff",
    "rust_analyzer",
    "sourcekit",
    "vtsls",
    "volar",
    "yamlls",
}
vim.lsp.enable(clients)

vim.api.nvim_create_autocmd("LspNotify", {
    callback = function(args)
        local bufnr = args.buf
        local winnr = vim.fn.bufwinid(bufnr)
        if vim.wo[winnr].diff then return end
        if args.data.method == "textDocument/didOpen" then vim.lsp.foldclose("imports", winnr) end
    end,
})

local kind_hlgroups = {
    Text = "@string",
    Method = "@function.method",
    Function = "@function",
    Constructor = "@constructor",
    Field = "@variable.member",
    Variable = "@variable",
    Class = "@type",
    Interface = "@type",
    Module = "@module",
    Property = "@property",
    Unit = "@number",
    Value = "@string",
    Enum = "@type",
    Keyword = "@keyword",
    Snippet = "@string.special",
    Color = "@string.special",
    File = "@string.special.path",
    Reference = "@string.special",
    Folder = "@string.special.path",
    EnumMember = "@constant",
    Constant = "@constant",
    Struct = "@type",
    Event = "@function",
    Operator = "@operator",
    TypeParameter = "@type.parameter",
}

-- Nerd Font icons for completion item kinds.
local kind_icons = {
    Text = "󰉿",
    Method = "󰊕",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "󰎠",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then return end

        -- if LSP client supports it, use LSP for folding instead of TreeSitter
        if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
            vim.wo[win][0].foldmethod = "expr"
        end

        -- Enable native LSP autocompletion
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
                convert = function(item)
                    local word = item.label
                    local abbr = word
                    local max_w = vim.o.pummaxwidth - 10

                    -- Shorten long labels to fit the popup menu
                    if max_w > 0 and #abbr > max_w then abbr = abbr:sub(1, max_w - 3) .. "..." end

                    local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind] or ""
                    local hl = kind_hlgroups[kind_name]
                    local icon = kind_icons[kind_name] or "?"

                    return {
                        word = word,
                        abbr = abbr,
                        kind = icon,
                        kind_hlgroup = hl,
                        menu = " " .. client.name,
                    }
                end,
            })
        end
    end,
})
