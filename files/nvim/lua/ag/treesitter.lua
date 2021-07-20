require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of
    -- languages
    ensure_installed = "maintained",
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
            keymaps = {
                goto_next_start = {
                    ["]]"] = "@function.outer",
                },
                goto_next_end = {
                    ["[]"] = "@function.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                },
                goto_previous_end = {
                    ["]["] = "@function.outer",
                },
            },
        },
        -- peek definitions from LSP
        lsp_interop = {
            enable = true,
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
    refactor = {
        highlight_definitions = {
            enable = true,
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "gr",
            },
        },
    },
}
