-- Obsidian go to "definition" (file)
local function get_text_inside_square_brackets()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local cursor_row = cursor_pos[1]

    local line = vim.fn.getline(cursor_row)
    local fname = line:match("%[%[(.+)%]%]")

    return fname
end

vim.keymap.set("n", "<C-]>", function()
    local fname = get_text_inside_square_brackets() .. ".md"
    vim.cmd('find ++edit' .. fname)
end, { silent = true, buffer = true, desc = "Goto file reference"})
