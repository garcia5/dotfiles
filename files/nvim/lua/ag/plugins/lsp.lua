local lsp_config = {
    "neovim/nvim-lspconfig",
    config = function()
        require("ag.lsp_config")
        require("ag.diagnostics")
    end,
    ft = {
        "vue",
        "typescript",
        "json",
        "javascript",
        "go",
        "rust",
        "lua",
        "python",
        "yaml",
        "bash",
        "zsh",
        "dart",
        "scala",
        "sbt",
        "java",
    },
}

local efm = {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        local eslint = require("efmls-configs.linters.eslint_d")
        local prettier = require("efmls-configs.formatters.prettier_d")
        local stylua = require("efmls-configs.formatters.stylua")
        local black = require("efmls-configs.formatters.black")
        local flake8 = require("efmls-configs.linters.flake8")
        local pylint = require("efmls-configs.linters.pylint")
        local autopep8 = require("efmls-configs.formatters.autopep8")
        local shellcheck = require("efmls-configs.linters.shellcheck")

        local languages = {
            lua = { stylua },
            typescript = { prettier, eslint },
            javascript = { prettier, eslint },
            vue = { prettier, eslint },
            python = { black, autopep8, flake8, pylint },
            bash = { shellcheck },
            sh = { shellcheck },
        }

        -- special handling for python to use virtual envs w/o activating
        local pipenv_venv_path = require("ag.utils").get_pipenv_venv_path()
        if pipenv_venv_path ~= nil then
            local cmd_prefix = pipenv_venv_path .. "/bin/"
            for _, prog in ipairs(languages["python"]) do
                if prog["formatCommand"] then prog["formatCommand"] = cmd_prefix .. prog["formatCommand"] end
                if prog["lintCommand"] then prog["lintCommand"] = cmd_prefix .. prog["lintCommand"] end
            end
        end

        -- explicitly point stylua to my config
        local format_cmd = languages["lua"][1]["formatCommand"]
        local new_cmd = format_cmd:gsub("(stylua)", "%1 --config-path .stylua.toml")
        languages["lua"][1]["formatCommand"] = new_cmd

        local efmls_config = {
            filetypes = vim.tbl_keys(languages),
            settings = {
                rootMarkers = { ".git/" },
                languages = languages,
            },
            init_options = {
                documentFormatting = true,
                documentRangeFormatting = true,
            },
        }

        require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
            on_attach = function(client, bufnr)
                require("ag.lsp_config").custom_attach(client, bufnr, { allowed_clients = { "efm" } })
            end,
        }))
    end,
    ft = {
        "lua",
        "typescript",
        "javascript",
        "vue",
        "python",
        "bash",
        "sh",
    },
}

local metals = {
    "scalameta/nvim-metals",
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
        local metals_config = require("metals").bare_config()

        metals_config.settings = {
            showImplicitArguments = true,
            showInferredType = true,
            superMethodLensesEnabled = true,
            serverVersion = "latest.snapshot",
            sbtScript = "/opt/homebrew/bin/sbt",
            useGlobalExecutable = false,
            autoImportBuild = "all",
        }

        metals_config.init_options.statusBarProvider = "on"

        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

        metals_config.on_attach = function(client, bufnr)
            local custom_attach = require("ag.lsp_config").custom_attach
            custom_attach(client, bufnr, { format_on_save = false, allowed_clients = { "metals" } })
        end

        return metals_config
    end,
    config = function(self, config)
        vim.opt_global.shortmess:remove("F")
        local metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = self.ft,
            callback = function() require("metals").initialize_or_attach(config) end,
            group = metals_group,
        })
    end,
}

return {
    lsp_config,
    efm,
    metals,
}
