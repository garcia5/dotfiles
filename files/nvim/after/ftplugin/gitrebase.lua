-- EZ rebase keybinds
for _, key in ipairs({ "P", "R", "E", "S", "F", "D", "X", "B", "L", "R", "T", "M" }) do
    vim.keymap.set("n", key, "ciw" .. string.lower(key) .. "<Esc>", { noremap = true, silent = true, buffer = true })
end
