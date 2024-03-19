return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        -- extra textobjects
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- commenting for vue SFCs
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            ft = { "vue" },
            config = function()
                vim.g.skip_ts_context_commentstring_module = true
                require("ts_context_commentstring").setup()
            end,
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
    config = function()
        vim.opt.foldmethod = "expr" -- use function to determine folds
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use TS for folding

        require("nvim-treesitter.configs").setup({
            -- either "all" or a list of languages
            ensure_installed = "all",
            ignore_install = { "fusion", "blueprint", "jsonc", "t32" }, -- issues with tarball extraction
            highlight = {
                -- false will disable the whole extension
                enable = true,
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
            autotag = {
                enable = true,
                filetypes = { "html", "vue" },
            },
        })
    end,
}
