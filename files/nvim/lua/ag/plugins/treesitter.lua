local ts = {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
        -- extra textobjects
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- commenting for vue SFCs
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            ft = { "vue" },
            init = function() vim.g.skip_ts_context_commentstring_module = true end,
            config = true,
        },
        -- auto insert closing tags
        {
            "windwp/nvim-ts-autotag",
            ft = {
                "html",
                "vue",
            },
        },
    },
    init = function()
        vim.opt.foldmethod = "expr" -- use function to determine folds
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use TS for folding
    end,
    opts = {
        -- either "all" or a list of languages
        ensure_installed = "all",
        ignore_install = { "fusion", "blueprint", "jsonc", "t32" }, -- issues with tarball extraction
        highlight = {
            -- false will disable the whole extension
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
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
                    ["]["] = "@function.outer",
                    [")("] = "@class.outer",
                },
                goto_next_end = {
                    ["]]"] = "@function.outer",
                    ["))"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["(("] = "@class.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["()"] = "@class.outer",
                },
            },
            -- peek definitions from LSP
            lsp_interop = {
                enable = true,
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
                    ["<Leader>h"] = "@parameter.inner",
                },
            },
        },
        autotag = {
            enable = true,
            filetypes = { "html", "vue" },
        },
    },
}

local ts_context = {
    "nvim-treesitter/nvim-treesitter-context",
    init = function()
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
            underline = true,
            sp = "Grey",
        })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {
            underline = true,
            sp = "Grey",
        })
    end,
    opts = {
        enable = false,
        max_lines = 5, -- How many lines the window should span
        min_window_height = 25,
        line_numbers = true,
        multiline_threshold = 5, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
    },
}

return {
    ts,
    ts_context,
}
