local custom_attach = require("ag.lsp.common").custom_attach

local inlay_hint_settings = {
    parameterNames = {
        enabled = "all", -- Enable parameter name hints only for literal arguments
        suppressWhenArgumentMatchesName = true, -- Suppress parameter name hints on arguments whose text is identical to the parameter name
    },
    propertyDeclarationTypes = {
        enabled = true, -- Enable inlay hints for implicit types on property declarations
    },
    functionLikeReturnTypes = {
        enabled = true, -- Enable inlay hints for implicit return types on function signatures
    },
}

---see: https://github.com/yioneko/nvim-vtsls/blob/main/README.md#other-useful-snippets
local register_nvim_tree_rename = function()
    local success, api = pcall(require, "nvim-tree.api")
    if not success then return end

    local path_sep = package.config:sub(1, 1)

    local function trim_sep(path) return path:gsub(path_sep .. "$", "") end

    local function uri_from_path(path) return vim.uri_from_fname(trim_sep(path)) end

    local function is_sub_path(path, folder)
        path = trim_sep(path)
        folder = trim_sep(folder)
        if path == folder then
            return true
        else
            return path:sub(1, #folder + 1) == folder .. path_sep
        end
    end

    local function check_folders_contains(workspace_folders, path)
        if workspace_folders == nil then return false end

        for _, folder in pairs(workspace_folders) do
            if is_sub_path(path, folder.name) then return true end
        end
        return false
    end

    local function match_file_operation_filter(filter, name, type)
        if filter.scheme and filter.scheme ~= "file" then
            -- we do not support uri scheme other than file
            return false
        end
        local pattern = filter.pattern
        local matches = pattern.matches

        if type ~= matches then return false end

        local regex_str = vim.fn.glob2regpat(pattern.glob)
        if vim.tbl_get(pattern, "options", "ignoreCase") then regex_str = "\\c" .. regex_str end
        return vim.regex(regex_str):match_str(name) ~= nil
    end

    api.events.subscribe(api.events.Event.NodeRenamed, function(data)
        local stat = vim.loop.fs_stat(data.new_name)
        if not stat then return end
        local type = ({ file = "file", directory = "folder" })[stat.type]
        local clients = vim.lsp.get_clients({})
        for _, client in ipairs(clients) do
            if check_folders_contains(client.workspace_folders, data.old_name) then
                local filters = vim.tbl_get(
                    client.server_capabilities,
                    "workspace",
                    "fileOperations",
                    "didRename",
                    "filters"
                ) or {}
                for _, filter in pairs(filters) do
                    if
                        match_file_operation_filter(filter, data.old_name, type)
                        and match_file_operation_filter(filter, data.new_name, type)
                    then
                        client:notify("workspace/didRenameFiles", {
                            files = {
                                { oldUri = uri_from_path(data.old_name), newUri = uri_from_path(data.new_name) },
                            },
                        })
                    end
                end
            end
        end
    end)
end

return {
    cmd = { "vtsls", "--stdio" },
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr)

        -- integrate w/ nvim-tree renames
        if not vim.g.loaded_vtsls_nvim_tree then
            register_nvim_tree_rename()
            vim.g.loaded_vtsls_nvim_tree = true
        end

        -- organize imports
        require("ag.utils").register_organize_imports("vtsls", bufnr)
    end,
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
    init_options = {
        hostInfo = "neovim",
    },
    -- see: https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
    settings = {
        javascript = {
            inlayHints = vim.tbl_extend("force", inlay_hint_settings, {
                parameterTypes = {
                    enabled = true,
                },
                variableTypes = {
                    enabled = true,
                },
            }),
        },
        typescript = {
            inlayHints = inlay_hint_settings,
        },
        vtsls = {
            -- auto detect project typescript installation and use it, rather than using
            -- bundled vtsls typescript version
            autoUseWorkspaceTsdk = true,
        },
    },
}
