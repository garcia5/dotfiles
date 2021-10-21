require'nvim-treesitter.configs'.setup({
    -- one of "all", "maintained" (parsers with maintainers), or a list of
    -- languages
    ensure_installed = "maintained",
    highlight = {
        -- false will disable the whole extension
        enable = true,
    },
    indent = {
        enable = false,
    },
    -- custom text objects
    textobjects = {
        -- change/delete/select in function or class
        select = {
            enable = true,
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
            border = 'single',
            peek_definition_code = {
                ["<Leader>pf"] = "@function.outer",
                ["<Leader>pc"] = "@class.outer",
            }
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
})
