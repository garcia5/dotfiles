require'format'.setup {
    python = {
        {cmd={"yapf -i"}},
    },
    typescript = {
        {cmd={[[sed -Ei 's/[  ]+$//']]}},
    },
}
