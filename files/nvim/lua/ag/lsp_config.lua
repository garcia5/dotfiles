local lspconfig = require("lspconfig")

local M = {}

-- Give floating windows borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

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

---@param client any the lsp client instance
---@param bufnr number buffer we're attaching to
---@param format_opts table how to deal with formatting, takes the following keys:
-- allowed_clients (string[]): names of the lsp clients that are allowed to handle vim.lsp.buf.format() when this client is attached
-- format_on_save (bool): whether or not to auto format on save
M.custom_attach = function(client, bufnr, format_opts)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    local with_desc = function(opts, desc) return vim.tbl_extend("force", opts, { desc = desc }) end

    vim.keymap.set("n", "K", vim.lsp.buf.hover, with_desc(keymap_opts, "Hover"))
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, with_desc(keymap_opts, "Goto Definition"))
    vim.keymap.set("n", "<leader>gr", "<cmd>Glance references<CR>", with_desc(keymap_opts, "Find References"))
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, with_desc(keymap_opts, "Rename"))

    -- diagnostics
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.open_float, with_desc(keymap_opts, "View Current Diagnostic")) -- diagnostic(s) on current line
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, with_desc(keymap_opts, "Goto next diagnostic")) -- move to next diagnostic in buffer
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, with_desc(keymap_opts, "Goto prev diagnostic")) -- move to prev diagnostic in buffer
    vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, with_desc(keymap_opts, "Populate qf list")) -- show all buffer diagnostics in qflist
    vim.keymap.set("n", "H", function()
        -- make sure telescope is loaded for code actions
        require("telescope").load_extension("ui-select")
        vim.lsp.buf.code_action()
    end, with_desc(keymap_opts, "Code Actions")) -- code actions (handled by telescope-ui-select)
    vim.keymap.set("n", "<Leader>rr", "<cmd>LspRestart<CR>", with_desc(keymap_opts, "Restart all LSP clients")) -- restart clients

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

--#region Set up clients
-- python
lspconfig.pyright.setup({
    on_new_config = function(new_config)
        local python_path = require("ag.utils").get_pipenv_venv_path()
        if python_path ~= nil then new_config.settings.python.pythonPath = python_path .. "/bin/python" end
    end,
    on_attach = function(client, bufnr)
        M.custom_attach(client, bufnr, { allowed_clients = { "efm" } })
        -- 'Organize imports' keymap for pyright only
        vim.keymap.set("n", "<Leader>ii", "<cmd>PyrightOrganizeImports<CR>", {
            buffer = bufnr,
            silent = true,
            noremap = true,
        })
    end,
    settings = {
        pyright = {
            disableOrganizeImports = false,
            analysis = {
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
            },
        },
    },
})

-- Use project-local typescript installation if available, fallback to global install
-- assumes typescript installed globally w/ nvm
local function get_typescript_server_path(root_dir)
    local global_ts = vim.fn.expand("$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION/lib/node_modules/typescript/lib")
    local project_ts = ""
    local function check_dir(path)
        project_ts = lspconfig.util.path.join(path, "node_modules", "typescript", "lib")
        if lspconfig.util.path.exists(project_ts) then return path end
    end
    if lspconfig.util.search_ancestors(root_dir, check_dir) then
        return project_ts
    else
        return global_ts
    end
end

-- ts/js/vue
lspconfig.volar.setup({
    on_attach = function(client, bufnr) M.custom_attach(client, bufnr, { allowed_clients = { "efm" } }) end,
    -- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
    filetypes = { "typescript", "javascript", "vue" },
    on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
    end,
})

-- yaml
lspconfig.yamlls.setup({
    autostart = false,
    on_attach = function(client, bufnr)
        M.custom_attach(client, bufnr, { allowed_clients = { "efm" }, format_on_save = false })
    end,
})

-- bash
lspconfig.bashls.setup({
    on_attach = M.custom_attach,
    filetypes = { "bash", "sh", "zsh" },
})

-- lua
lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        M.custom_attach(client, bufnr, { allowed_clients = { "efm" }, format_on_save = true })
    end,
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        })
    end,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
        },
    },
})

-- json w/ common schemas
lspconfig.jsonls.setup({
    on_attach = M.custom_attach,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

-- rust
lspconfig.rust_analyzer.setup({
    on_attach = function(client, bufnr)
        M.custom_attach(client, bufnr, { format_on_save = true, allowed_clients = { "rust_analyzer" } })
    end,
})

-- go
lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        M.custom_attach(client, bufnr, { allowed_clients = { "gopls" }, format_on_save = true })
        -- auto organize imports
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
            end,
        })
    end,
})

-- dart
lspconfig.dartls.setup({
    on_attach = function(client, bufnr)
        M.custom_attach(client, bufnr, { allowed_clients = { "dartls" }, format_on_save = true })
    end,
})
--#endregion

return M
