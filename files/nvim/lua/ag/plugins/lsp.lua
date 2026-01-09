local efm = {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x",
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

local vtsls = {
    "yioneko/nvim-vtsls",
    ft = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    cmd = {
        "VtsExec",
        "VtsRename",
    }
}

return {
    efm,
    vtsls,
}
