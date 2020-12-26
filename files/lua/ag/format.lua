require 'format'.setup {
    python = {
        {cmd={"black"}}
    },
    ["*"] = {
        {cmd={[[sed -i 's/[ \t]*$//']]}}
    }
}
