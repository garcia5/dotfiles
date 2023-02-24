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
        },
        -- rainbow braces
        "mrjones2014/nvim-ts-rainbow",
        -- auto insert closing tags
        {
            "windwp/nvim-ts-autotag",
            ft = {
                "html",
                "vue",
            },
        },
        -- View treesitter info
        "nvim-treesitter/playground",
    },
    config = function()
        vim.opt.foldmethod = "expr" -- use function to determine folds
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter for folding

        require("nvim-treesitter.configs").setup({
            -- either "all" or a list of languages
            ensure_installed = "all",
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
                enable_autocmd = false, -- Comment.nvim takes care of this automatically
            },
            rainbow = {
                enable = true,
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags
                max_file_lines = 10000,
            },
            autotag = {
                enable = true,
                filetypes = { "html", "vue" },
            },
            playground = {
                enabled = true,
            },
        })
    end,
}
