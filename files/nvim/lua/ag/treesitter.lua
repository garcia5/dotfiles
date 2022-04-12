vim.opt.foldmethod = "expr" -- use function to determine folds
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter for folding

require("nvim-treesitter.configs").setup({
    -- either "all" or a list of languages
    ensure_installed = {
        "javascript",
        "jsonc",
        "comment",
        "jsdoc",
        "tsx",
        "html",
        "vue",
        "typescript",
        "python",
        "regex",
        "bash",
        "lua",
        "css",
        "scss",
        "yaml",
    },
    highlight = {
        -- false will disable the whole extension
        enable = true,
    },
    indent = {
        enable = false, -- buggy :/
    },
    -- custom text objects
    textobjects = {
        -- change/delete/select in function or class
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        -- easily move to next function/class
        move = {
            enable = true,
            set_jumps = true, -- track in jumplist (<C-o>, <C-i>)
            goto_next_start = {
                ["]]"] = "@function.outer",
                ["))"] = "@class.outer",
            },
            goto_next_end = {
                ["[]"] = "@function.outer",
                ["()"] = "@class.outer",
            },
            goto_previous_start = {
                ["[["] = "@function.outer",
                ["(("] = "@class.outer",
            },
            goto_previous_end = {
                ["]["] = "@function.outer",
                [")("] = "@class.outer",
            },
        },
        -- peek definitions from LSP
        lsp_interop = {
            enable = true,
            border = "single",
            peek_definition_code = {
                ["<Leader>pf"] = "@function.outer",
                ["<Leader>pc"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<Leader>l"] = "@parameter.inner",
            },
            swap_previous = {
                ["<Leader>h"] = "@parameter.outer",
            },
        },
    },
    context_commentstring = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags
    },
    autotag = {
        enable = true,
        filetypes = { "html", "vue" },
    },
})
