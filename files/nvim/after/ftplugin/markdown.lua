-- Obsidian go to "definition" (file)
local function get_text_inside_double_square_brackets()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local cursor_row = cursor_pos[1]

    local line = vim.fn.getline(cursor_row)
    local text = line:match("%[%[(.+)%]%]")

    return text
end

vim.keymap.set("n", "<C-]>", function()
    local text = get_text_inside_double_square_brackets()
    if text ~= nil then
        local fname = get_text_inside_double_square_brackets() .. ".md"
        vim.cmd("find ++edit" .. fname, { desc = "Goto file reference" })
    end
end)

vim.bo.textwidth = 120
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.opt_local.wrap = true
vim.opt.formatoptions = vim.opt.formatoptions + "ta"
