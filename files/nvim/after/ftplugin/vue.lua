vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2

-- special commenting for vue SFCs
require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

--[[
Mappings shamelessly stolen from medium article:
https://medium.com/scoro-engineering/5-smart-mini-snippets-for-making-text-editing-more-fun-in-neovim-b55ffb96325a
--]]
-- automatically add "" when adding attributes in vue
vim.keymap.set("i", "=", function()
    -- The cursor location does not give us the correct node in this case, so we
    -- need to get the node to the left of the cursor
    local cursor = vim.api.nvim_win_get_cursor(0)
    local left_of_cursor_range = { cursor[1] - 1, cursor[2] - 1 }

    local node = vim.treesitter.get_node({ pos = left_of_cursor_range })
    local nodes_active_in = {
        "attribute_name",
        "directive_argument",
        "directive_name",
    }
    if not node or not vim.tbl_contains(nodes_active_in, node:type()) then
        -- The cursor is not on an attribute node
        return "="
    end

    return '=""<left>'
end, { expr = true, buffer = true, desc = "Smart vue attribute insert" })

-- automatically turn {{| into {{ | }} in vue templates
local Rule = require("nvim-autopairs.rule")
local ts_conds = require("nvim-autopairs.ts-conds")
require("nvim-autopairs").add_rules({
    Rule("{{", "  }", "vue"):set_end_pair_length(2):with_pair(ts_conds.is_ts_node("text")),
})
