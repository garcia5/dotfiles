require'nvim-treesitter.configs'.setup {
    ensure_installed = { -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        "python",
        "typescript",
        "lua",
        "bash",
        "yaml",
        "json",
        "html",
        "css",
        "javascript",
    },
    highlight = {
        enable = true,   -- false will disable the whole extension
    },
    indent = {
        enable = true,
    },
}
