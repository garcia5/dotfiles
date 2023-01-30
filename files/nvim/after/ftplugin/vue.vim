setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

lua <<EOF
-- special commenting for vue SFCs
require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
EOF
