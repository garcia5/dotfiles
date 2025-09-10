local python = require("ag.snippets.python")
local typescript = require("ag.snippets.typescript")

return {
    typescript = typescript,
    python = vim.tbl_values(python),
}
